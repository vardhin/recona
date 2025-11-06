import 'dart:async';

/// Base class for all events
abstract class AppEvent {
  final String type;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  AppEvent(this.type, {this.metadata}) : timestamp = DateTime.now();
}

/// Base class for event responses - NOT abstract anymore!
class EventResponse {
  final bool success;
  final dynamic data;
  final String? error;

  EventResponse({
    required this.success,
    this.data,
    this.error,
  });
}

/// Event handler function type
typedef EventHandler<T extends AppEvent> = Future<EventResponse> Function(T event);

/// Middleware function type (runs before handlers)
typedef EventMiddleware<T extends AppEvent> = Future<bool> Function(T event);

/// Main EventBus class - Singleton pattern
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final Map<String, List<EventHandler>> _handlers = {};
  final Map<String, List<EventMiddleware>> _middlewares = {};
  final StreamController<AppEvent> _eventController = StreamController<AppEvent>.broadcast();

  /// Register an event handler
  void on<T extends AppEvent>(String eventType, EventHandler<T> handler) {
    if (!_handlers.containsKey(eventType)) {
      _handlers[eventType] = [];
    }
    _handlers[eventType]!.add(handler as EventHandler);
  }

  /// Register middleware for an event type
  void middleware<T extends AppEvent>(String eventType, EventMiddleware<T> middleware) {
    if (!_middlewares.containsKey(eventType)) {
      _middlewares[eventType] = [];
    }
    _middlewares[eventType]!.add(middleware as EventMiddleware);
  }

  /// Unregister an event handler
  void off(String eventType, [EventHandler? handler]) {
    if (handler == null) {
      _handlers.remove(eventType);
    } else {
      _handlers[eventType]?.remove(handler);
    }
  }

  /// Emit an event and get first successful response
  Future<EventResponse> emit<T extends AppEvent>(T event) async {
    _eventController.add(event);

    // Run middlewares first
    if (!await _runMiddlewares(event)) {
      return EventResponse(
        success: false,
        error: 'Event blocked by middleware',
      );
    }

    final handlers = _handlers[event.type];
    if (handlers == null || handlers.isEmpty) {
      return EventResponse(
        success: false,
        error: 'No handler registered for event type: ${event.type}',
      );
    }

    try {
      // Execute the first matching handler
      final response = await handlers.first(event);
      return response;
    } catch (e) {
      return EventResponse(
        success: false,
        error: 'Error handling event: $e',
      );
    }
  }

  /// Emit event to all handlers (broadcast) - executes in parallel
  Future<List<EventResponse>> emitToAll<T extends AppEvent>(T event) async {
    _eventController.add(event);

    // Run middlewares first
    if (!await _runMiddlewares(event)) {
      return [
        EventResponse(
          success: false,
          error: 'Event blocked by middleware',
        )
      ];
    }

    final handlers = _handlers[event.type];
    if (handlers == null || handlers.isEmpty) {
      return [
        EventResponse(
          success: false,
          error: 'No handlers registered for event type: ${event.type}',
        )
      ];
    }

    // Execute all handlers in parallel
    final futures = handlers.map((handler) async {
      try {
        return await handler(event);
      } catch (e) {
        return EventResponse(
          success: false,
          error: 'Error in handler: $e',
        );
      }
    });

    return await Future.wait(futures);
  }

  /// Emit event to all handlers in sequence (one after another)
  Future<List<EventResponse>> emitSequential<T extends AppEvent>(T event) async {
    _eventController.add(event);

    // Run middlewares first
    if (!await _runMiddlewares(event)) {
      return [
        EventResponse(
          success: false,
          error: 'Event blocked by middleware',
        )
      ];
    }

    final handlers = _handlers[event.type];
    if (handlers == null || handlers.isEmpty) {
      return [
        EventResponse(
          success: false,
          error: 'No handlers registered for event type: ${event.type}',
        )
      ];
    }

    final responses = <EventResponse>[];
    for (final handler in handlers) {
      try {
        final response = await handler(event);
        responses.add(response);
        
        // Stop if handler fails and you want to stop on first failure
        // if (!response.success) break;
      } catch (e) {
        responses.add(EventResponse(
          success: false,
          error: 'Error in handler: $e',
        ));
      }
    }

    return responses;
  }

  /// Emit and wait for all handlers, return combined result
  Future<EventResponse> emitAndCombine<T extends AppEvent>(
    T event, {
    bool stopOnFailure = false,
  }) async {
    final responses = await emitSequential(event);
    
    final failedResponses = responses.where((r) => !r.success).toList();
    
    if (failedResponses.isNotEmpty) {
      return EventResponse(
        success: false,
        error: failedResponses.map((r) => r.error).join(', '),
        data: {'responses': responses},
      );
    }

    return EventResponse(
      success: true,
      data: {
        'responses': responses,
        'results': responses.map((r) => r.data).toList(),
      },
    );
  }

  /// Run all middlewares for an event
  Future<bool> _runMiddlewares<T extends AppEvent>(T event) async {
    final middlewares = _middlewares[event.type];
    if (middlewares == null || middlewares.isEmpty) return true;

    for (final middleware in middlewares) {
      if (!await middleware(event)) {
        return false;
      }
    }
    return true;
  }

  /// Get event stream for listening
  Stream<AppEvent> get stream => _eventController.stream;

  /// Get stream for specific event type
  Stream<T> streamOf<T extends AppEvent>(String eventType) {
    return _eventController.stream
        .where((event) => event.type == eventType)
        .cast<T>();
  }

  /// Clear all handlers
  void clearAll() {
    _handlers.clear();
    _middlewares.clear();
  }

  /// Dispose the event bus
  void dispose() {
    _eventController.close();
    _handlers.clear();
    _middlewares.clear();
  }
}