import 'event_bus.dart';

// Import only the handlers you have
import '../handlers/message_handlers.dart';
// import '../handlers/auth_handlers.dart';  // Comment out for now
// import '../handlers/call_handlers.dart';  // Comment out for now

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final EventBus _eventBus = EventBus();
  bool _initialized = false;

  EventBus get eventBus => _eventBus;

  Future<void> initialize() async {
    if (_initialized) return;

    // Register only message handlers for now
    _eventBus.middleware('message.send', MessageHandlers.validateMessage);
    _eventBus.on('message.send', MessageHandlers.handleSendMessage);
    _eventBus.on('message.delete', MessageHandlers.handleDeleteMessage);
    _eventBus.on('message.read', MessageHandlers.handleMarkAsRead);
    _eventBus.on('message.typing', MessageHandlers.handleTyping);

    // Add more as you create them
    // _eventBus.on('auth.login', AuthHandlers.login);
    
    _initialized = true;
  }

  void dispose() {
    _eventBus.dispose();
    _initialized = false;
  }
}