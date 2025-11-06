import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];
  Map<String, List<Message>> _messages = {};
  bool _isLoading = false;

  List<Chat> get chats => List.unmodifiable(_chats);
  bool get isLoading => _isLoading;

  // Get messages for a specific chat
  List<Message> getMessages(String chatId) {
    return _messages[chatId] ?? [];
  }

  // Search chats
  List<Chat> searchChats(String query) {
    if (query.isEmpty) return _chats;
    
    final lowercaseQuery = query.toLowerCase();
    return _chats.where((chat) {
      return chat.contactName.toLowerCase().contains(lowercaseQuery) ||
          chat.lastMessage.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Add a new chat
  void addChat(Chat chat) {
    _chats.insert(0, chat);
    notifyListeners();
  }

  // Send a message
  void sendMessage(Message message) {
    if (!_messages.containsKey(message.chatId)) {
      _messages[message.chatId] = [];
    }
    _messages[message.chatId]!.add(message);
    
    // Update chat last message
    final chatIndex = _chats.indexWhere((c) => c.id == message.chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(
        lastMessage: message.content,
        lastMessageTime: message.timestamp,
      );
      // Move to top
      final chat = _chats.removeAt(chatIndex);
      _chats.insert(0, chat);
    }
    
    notifyListeners();
  }

  // Mark messages as read
  void markAsRead(String chatId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  // Toggle pin
  void togglePin(String chatId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(
        isPinned: !_chats[chatIndex].isPinned,
      );
      notifyListeners();
    }
  }

  // Toggle mute
  void toggleMute(String chatId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(
        isMuted: !_chats[chatIndex].isMuted,
      );
      notifyListeners();
    }
  }

  // Delete chat
  void deleteChat(String chatId) {
    _chats.removeWhere((c) => c.id == chatId);
    _messages.remove(chatId);
    notifyListeners();
  }

  // Clear all messages in a chat
  void clearMessages(String chatId) {
    _messages[chatId] = [];
    notifyListeners();
  }
}