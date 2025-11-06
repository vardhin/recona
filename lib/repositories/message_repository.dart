import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message.dart';
import '../services/storage_service.dart';

class MessageRepository {
  static final MessageRepository _instance = MessageRepository._internal();
  factory MessageRepository() => _instance;
  MessageRepository._internal();

  final String _baseUrl = 'https://your-api.com/api';

  // In-memory storage for now (you can add Hive/SQLite later)
  final Map<String, List<Message>> _messages = {};

  /// Save message to local storage
  Future<void> save(Message message) async {
    if (!_messages.containsKey(message.chatId)) {
      _messages[message.chatId] = [];
    }
    _messages[message.chatId]!.add(message);
    print('✅ Message saved: ${message.content}');
  }

  /// Sync message to server
  Future<void> syncToServer(Message message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to sync message');
      }
    } catch (e) {
      print('Sync failed, will retry later: $e');
      // Queue for retry
      await StorageService().queueForSync(message);
    }
  }

  /// Delete message
  Future<void> delete(String messageId) async {
    for (var messages in _messages.values) {
      messages.removeWhere((msg) => msg.id == messageId);
    }
    print('🗑️ Message deleted: $messageId');
  }

  /// Sync deletion to server
  Future<void> syncDeleteToServer(String messageId) async {
    try {
      await http.delete(
        Uri.parse('$_baseUrl/messages/$messageId'),
      );
    } catch (e) {
      print('Delete sync failed: $e');
    }
  }

  /// Notify deletion to other users
  Future<void> notifyDeletion(String chatId, String messageId) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/messages/$messageId/notify-delete'),
        body: json.encode({'chatId': chatId}),
      );
    } catch (e) {
      print('Notification failed: $e');
    }
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId) async {
    for (var messages in _messages.values) {
      for (var msg in messages) {
        if (msg.id == messageId) {
          // Update status (you'll need to make Message mutable or use copyWith)
          print('✅ Marked as read: $messageId');
          break;
        }
      }
    }

    try {
      await http.patch(
        Uri.parse('$_baseUrl/messages/$messageId/read'),
      );
    } catch (e) {
      print('Mark as read sync failed: $e');
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(String chatId, bool isTyping) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/chats/$chatId/typing'),
        body: json.encode({'isTyping': isTyping}),
      );
    } catch (e) {
      print('Typing indicator failed: $e');
    }
  }

  /// Get messages for a chat
  List<Message> getMessages(String chatId) {
    return _messages[chatId] ?? [];
  }

  /// Fetch messages from server
  Future<List<Message>> fetchMessages(String chatId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return getMessages(chatId);
  }
}