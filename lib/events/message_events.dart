import '../services/event_bus.dart';
import '../models/message.dart';

/// Send message event
class SendMessageEvent extends AppEvent {
  final String chatId;
  final String content;
  final String? replyToId;

  SendMessageEvent({
    required this.chatId,
    required this.content,
    this.replyToId,
  }) : super('message.send');
}

/// Delete message event
class DeleteMessageEvent extends AppEvent {
  final String messageId;
  final String chatId;

  DeleteMessageEvent({
    required this.messageId,
    required this.chatId,
  }) : super('message.delete');
}

/// Edit message event
class EditMessageEvent extends AppEvent {
  final String messageId;
  final String newContent;

  EditMessageEvent({
    required this.messageId,
    required this.newContent,
  }) : super('message.edit');
}

/// Mark message as read event
class MarkMessageReadEvent extends AppEvent {
  final String messageId;
  final String chatId;

  MarkMessageReadEvent({
    required this.messageId,
    required this.chatId,
  }) : super('message.read');
}

/// Typing indicator event
class TypingEvent extends AppEvent {
  final String chatId;
  final bool isTyping;

  TypingEvent({
    required this.chatId,
    required this.isTyping,
  }) : super('message.typing');
}

/// Message sent response
class MessageSentResponse extends EventResponse {
  final Message? message;

  MessageSentResponse({
    required bool success,
    this.message,
    String? error,
  }) : super(success: success, data: message, error: error);
}