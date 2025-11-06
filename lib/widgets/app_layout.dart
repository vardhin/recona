import 'package:flutter/material.dart';
import 'navbar.dart';
import 'footer_bar.dart';
import '../screens/chats_screen.dart';
import '../screens/calls_screen.dart';
import '../screens/contacts_screen.dart';

class AppLayout extends StatefulWidget {
  final Widget? child;
  final int initialTab;

  const AppLayout({
    Key? key,
    this.child,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late int _currentTab;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChanged(int index) {
    setState(() {
      _currentTab = index;
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentTab) {
      case 0:
        return ChatsScreen(
          searchQuery: _searchController.text,
        );
      case 1:
        return CallsScreen(
          searchQuery: _searchController.text,
        );
      case 2:
        return ContactsScreen(
          searchQuery: _searchController.text,
        );
      default:
        return widget.child ?? const SizedBox.shrink();
    }
  }

  String _getScreenTitle() {
    switch (_currentTab) {
      case 0:
        return 'Chats';
      case 1:
        return 'Calls';
      case 2:
        return 'Contacts';
      default:
        return 'Recona';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update search
                },
              )
            : Text(_getScreenTitle()),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 8),
                    Text('About'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _getCurrentScreen(),
      bottomNavigationBar: FooterBar(
        currentIndex: _currentTab,
        onTabChanged: _handleTabChanged,
      ),
    );
  }
}