import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import 'package:flutter/foundation.dart';

class ContactStorageService {
  static const String _contactsKey = 'contacts';

  // Save contacts to local storage
  Future<void> saveContacts(List<Contact> contacts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = contacts.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      debugPrint('💾 Saving ${contacts.length} contacts to storage');
      debugPrint('📝 JSON: ${jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}...');
      
      final result = await prefs.setString(_contactsKey, jsonString);
      debugPrint('✅ Save result: $result');
      
      // Verify save
      final verify = prefs.getString(_contactsKey);
      debugPrint('🔍 Verification: ${verify != null ? "Data exists" : "Data NOT saved!"}');
    } catch (e) {
      debugPrint('❌ Failed to save contacts: $e');
      throw Exception('Failed to save contacts: $e');
    }
  }

  // Load contacts from local storage
  Future<List<Contact>> loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_contactsKey);
      
      debugPrint('📂 Loading contacts from storage');
      debugPrint('📄 Raw data: ${jsonString?.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}');
      
      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('⚠️ No contacts found in storage');
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      final contacts = jsonList.map((json) => Contact.fromJson(json as Map<String, dynamic>)).toList();
      
      debugPrint('✅ Loaded ${contacts.length} contacts');
      for (var contact in contacts) {
        debugPrint('  - ${contact.displayName} (${contact.id})');
      }
      
      return contacts;
    } catch (e) {
      debugPrint('❌ Failed to load contacts: $e');
      throw Exception('Failed to load contacts: $e');
    }
  }

  // Clear all contacts
  Future<void> clearContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_contactsKey);
      debugPrint('🗑️ Cleared all contacts from storage');
    } catch (e) {
      debugPrint('❌ Failed to clear contacts: $e');
      throw Exception('Failed to clear contacts: $e');
    }
  }

  // Debug: Check what's in storage
  Future<void> debugStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    debugPrint('🔑 All keys in SharedPreferences: $keys');
    final jsonString = prefs.getString(_contactsKey);
    debugPrint('📦 Contacts data: ${jsonString ?? "NULL"}');
  }
}