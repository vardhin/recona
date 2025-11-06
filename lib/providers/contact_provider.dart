import 'package:flutter/foundation.dart';
import '../models/contact.dart';
import '../services/contact_storage_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactStorageService _storageService = ContactStorageService();
  List<Contact> _contacts = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  List<Contact> get contacts => List.unmodifiable(_contacts);
  bool get isLoading => _isLoading;
  String? get error => _error;

  ContactProvider() {
    debugPrint('🚀 ContactProvider initialized');
    loadContacts();
  }

  // Load contacts from storage
  Future<void> loadContacts() async {
    if (_isLoading) {
      debugPrint('⏳ Already loading contacts, skipping...');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('📥 Loading contacts...');
      _contacts = await _storageService.loadContacts();
      _isLoading = false;
      _isInitialized = true;
      debugPrint('✅ Loaded ${_contacts.length} contacts');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ Error loading contacts: $e');
      notifyListeners();
    }
  }

  // Add a new contact
  Future<void> addContact(Contact contact) async {
    try {
      debugPrint('➕ Adding contact: ${contact.displayName}');
      _contacts.add(contact);
      await _storageService.saveContacts(_contacts);
      debugPrint('✅ Contact added and saved');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error adding contact: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Update an existing contact
  Future<void> updateContact(Contact updatedContact) async {
    try {
      debugPrint('✏️ Updating contact: ${updatedContact.displayName}');
      final index = _contacts.indexWhere((c) => c.id == updatedContact.id);
      if (index != -1) {
        _contacts[index] = updatedContact.copyWith(
          lastModified: DateTime.now(),
        );
        await _storageService.saveContacts(_contacts);
        debugPrint('✅ Contact updated and saved');
        notifyListeners();
      } else {
        debugPrint('⚠️ Contact not found for update');
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error updating contact: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Delete a contact
  Future<void> deleteContact(String contactId) async {
    try {
      debugPrint('🗑️ Deleting contact: $contactId');
      _contacts.removeWhere((c) => c.id == contactId);
      await _storageService.saveContacts(_contacts);
      debugPrint('✅ Contact deleted and saved');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error deleting contact: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Get contact by ID
  Contact? getContactById(String id) {
    try {
      return _contacts.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get contact by pubkey
  Contact? getContactByPubkey(String pubkey) {
    try {
      return _contacts.firstWhere((c) => c.pubkey == pubkey);
    } catch (e) {
      return null;
    }
  }

  // Search contacts
  List<Contact> searchContacts(String query) {
    if (query.isEmpty) return _contacts;
    
    final lowercaseQuery = query.toLowerCase();
    return _contacts.where((contact) {
      return contact.name.toLowerCase().contains(lowercaseQuery) ||
          (contact.nickname?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          contact.pubkey.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Debug method to check storage
  Future<void> debugCheckStorage() async {
    await _storageService.debugStorage();
  }
}