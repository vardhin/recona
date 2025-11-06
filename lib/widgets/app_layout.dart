import 'package:flutter/material.dart';
import 'navbar.dart';
import 'footer_bar.dart';

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;

  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
    // You can add navigation logic here based on the index
    // For example:
    // - index 0: Chats screen
    // - index 1: Calls screen
    // - index 2: Contacts screen
    // - index 3: Settings screen (handled in FooterBar)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: NavBar(),
      ),
      body: widget.child,
      bottomNavigationBar: FooterBar(
        onTabChanged: _handleTabChange,
      ),
    );
  }
}