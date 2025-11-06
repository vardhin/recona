import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 1,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.blue),
        ),
      ),
      title: const Text(
        'Recona',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Search functionality
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // More options menu
          },
          icon: const Icon(Icons.more_vert, color: Colors.white),
        ),
      ],
    );
  }
}