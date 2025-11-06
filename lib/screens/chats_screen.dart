import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/contact_provider.dart';
import '../models/chat.dart';
import '../models/contact.dart';
import 'chat_detail_screen.dart';
import 'package:uuid/uuid.dart';

class ChatsScreen extends StatefulWidget {
  final String? searchQuery;

  const ChatsScreen({
    Key? key,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: Consumer<ContactProvider>(
          builder: (context, contactProvider, child) {
            final contacts = contactProvider.contacts;
            
            if (contacts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No contacts available. Add contacts first.'),
              );
            }

            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: contact.profilePicUrl != null
                          ? NetworkImage(contact.profilePicUrl!)
                          : null,
                      child: contact.profilePicUrl == null
                          ? Text(contact.name[0].toUpperCase())
                          : null,
                    ),
                    title: Text(contact.displayName),
                    subtitle: Text(
                      contact.pubkey.length > 20
                          ? '${contact.pubkey.substring(0, 20)}...'
                          : contact.pubkey,
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close dialog first
                      _startNewChat(contact);
                    },
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _startNewChat(Contact contact) {
    final chatProvider = context.read<ChatProvider>();
    
    // Check if chat already exists
    final existingChat = chatProvider.chats.firstWhere(
      (c) => c.contactId == contact.id,
      orElse: () => Chat(
        id: const Uuid().v4(),
        contactId: contact.id,
        contactName: contact.displayName,
        contactProfilePic: contact.profilePicUrl,
        lastMessage: 'Start a conversation',
        lastMessageTime: DateTime.now(),
      ),
    );
    
    // Only add if it doesn't exist
    if (!chatProvider.chats.any((c) => c.contactId == contact.id)) {
      chatProvider.addChat(existingChat);
    }
    
    // Navigate to chat
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chat: existingChat),
      ),
    );
  }

  void _showChatOptions(Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(chat.isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                context.read<ChatProvider>().togglePin(chat.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(chat.isMuted ? Icons.notifications : Icons.notifications_off),
              title: Text(chat.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                context.read<ChatProvider>().toggleMute(chat.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Clear messages'),
              onTap: () {
                context.read<ChatProvider>().clearMessages(chat.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Messages cleared')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete chat', style: TextStyle(color: Colors.red)),
              onTap: () {
                context.read<ChatProvider>().deleteChat(chat.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final chats = widget.searchQuery != null && widget.searchQuery!.isNotEmpty
              ? chatProvider.searchChats(widget.searchQuery!)
              : chatProvider.chats;

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.searchQuery != null && widget.searchQuery!.isNotEmpty
                        ? 'No chats found'
                        : 'No chats yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation with your contacts',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showNewChatDialog,
                    icon: const Icon(Icons.add_comment),
                    label: const Text('Start New Chat'),
                  ),
                ],
              ),
            );
          }

          // Separate pinned and unpinned chats
          final pinnedChats = chats.where((c) => c.isPinned).toList();
          final unpinnedChats = chats.where((c) => !c.isPinned).toList();

          return ListView(
            children: [
              if (pinnedChats.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.push_pin, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Pinned',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ...pinnedChats.map((chat) => _buildChatTile(chat)),
                if (unpinnedChats.isNotEmpty)
                  Divider(height: 1, color: Colors.grey[300]),
              ],
              ...unpinnedChats.map((chat) => _buildChatTile(chat)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatDialog,
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildChatTile(Chat chat) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: chat.contactProfilePic != null
                ? NetworkImage(chat.contactProfilePic!)
                : null,
            child: chat.contactProfilePic == null
                ? Text(
                    chat.contactName.isNotEmpty 
                        ? chat.contactName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          if (chat.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.contactName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.isMuted)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.volume_off, size: 16, color: Colors.grey[600]),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: chat.unreadCount > 0 ? Colors.black : Colors.grey[600],
                fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: chat.unreadCount > 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
          ),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        context.read<ChatProvider>().markAsRead(chat.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chat: chat),
          ),
        );
      },
      onLongPress: () => _showChatOptions(chat),
    );
  }
}