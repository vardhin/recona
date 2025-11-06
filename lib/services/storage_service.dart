import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _syncQueueKey = 'sync_queue';

  Future<void> queueForSync(dynamic message) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing queue
    final queueJson = prefs.getString(_syncQueueKey);
    List<dynamic> queue = queueJson != null ? jsonDecode(queueJson) : [];
    
    // Add message to queue
    queue.add(message);
    
    // Save updated queue
    await prefs.setString(_syncQueueKey, jsonEncode(queue));
  }

  Future<List<dynamic>> getSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getString(_syncQueueKey);
    return queueJson != null ? jsonDecode(queueJson) : [];
  }

  Future<void> clearSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_syncQueueKey);
  }
}