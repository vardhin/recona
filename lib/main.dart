import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/app_layout.dart';
import 'providers/theme_provider.dart';
import 'providers/contact_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Recona',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home: const AppLayout(),
        );
      },
    );
  }
}