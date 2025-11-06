import '../services/event_bus.dart';
import '../events/message_events.dart';
import '../models/message.dart';
import '../repositories/message_repository.dart';
import 'package:uuid/uuid.dart';

class MessageHandlers {
  
  /// Middleware: Validate message before processing
  static Future<bool> validateMessage(AppEvent event) async {
    final sendEvent = event as SendMessageEvent;
    
    if (sendEvent.content.trim().isEmpty) {
      return false;
    }
    
    if (sendEvent.content.length > 5000) {
      return false;
    }
    
    return true;
  }

  /// Handler: Send message
  static Future<EventResponse> handleSendMessage(AppEvent event) async {
    try {
      final sendEvent = event as SendMessageEvent;
      
      final message = Message(
        id: const Uuid().v4(),
        chatId: sendEvent.chatId,
        senderId: 'me',
        content: sendEvent.content,
        timestamp: DateTime.now(),
        isMe: true,
        replyToId: sendEvent.replyToId,
      );

      // Save to database
      await MessageRepository().save(message);
      
      // Sync to server
      await MessageRepository().syncToServer(message);
      
      return MessageSentResponse(
        success: true,
        message: message,
      );
    } catch (e) {
      return MessageSentResponse(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Handler: Delete message
  static Future<EventResponse> handleDeleteMessage(AppEvent event) async {
    try {
      final deleteEvent = event as DeleteMessageEvent;
      
      await MessageRepository().delete(deleteEvent.messageId);
      await MessageRepository().syncDeleteToServer(deleteEvent.messageId);
      
      return EventResponse(
        success: true,
        data: {'messageId': deleteEvent.messageId},
      );
    } catch (e) {
      return EventResponse(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Handler: Mark as read
  static Future<EventResponse> handleMarkAsRead(AppEvent event) async {
    try {
      final readEvent = event as MarkMessageReadEvent;
      
      await MessageRepository().markAsRead(readEvent.messageId);
      
      return EventResponse(
        success: true,
        data: {'messageId': readEvent.messageId},
      );
    } catch (e) {
      return EventResponse(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Handler: Typing indicator
  static Future<EventResponse> handleTyping(AppEvent event) async {
    try {
      final typingEvent = event as TypingEvent;
      
      await MessageRepository().sendTypingIndicator(
        typingEvent.chatId,
        typingEvent.isTyping,
      );
      
      return EventResponse(success: true);
    } catch (e) {
      return EventResponse(success: false, error: e.toString());
    }
  }
}