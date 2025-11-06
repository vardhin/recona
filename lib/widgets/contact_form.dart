import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import '../config/app_theme.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;
  final Function(Contact) onSave;
  final VoidCallback? onCancel;

  const ContactForm({
    Key? key,
    this.contact,
    required this.onSave,
    this.onCancel,
  }) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _pubkeyController;
  late TextEditingController _profilePicController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _nicknameController = TextEditingController(text: widget.contact?.nickname ?? '');
    _pubkeyController = TextEditingController(text: widget.contact?.pubkey ?? '');
    _profilePicController = TextEditingController(text: widget.contact?.profilePicUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _pubkeyController.dispose();
    _profilePicController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        nickname: _nicknameController.text.trim().isEmpty
            ? null
            : _nicknameController.text.trim(),
        pubkey: _pubkeyController.text.trim(),
        profilePicUrl: _profilePicController.text.trim().isEmpty
            ? null
            : _profilePicController.text.trim(),
        createdAt: widget.contact?.createdAt,
      );
      widget.onSave(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name *',
              hintText: 'Enter contact name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: 'Nickname (Optional)',
              hintText: 'Enter nickname',
              prefixIcon: Icon(Icons.badge),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pubkeyController,
            decoration: const InputDecoration(
              labelText: 'Public Key *',
              hintText: 'Enter public key',
              prefixIcon: Icon(Icons.key),
            ),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a public key';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _profilePicController,
            decoration: const InputDecoration(
              labelText: 'Profile Picture URL (Optional)',
              hintText: 'Enter image URL',
              prefixIcon: Icon(Icons.image),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onCancel != null)
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleSave,
                child: Text(widget.contact == null ? 'Add Contact' : 'Update Contact'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}