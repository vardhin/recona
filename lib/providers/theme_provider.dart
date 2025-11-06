import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/theme_settings.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeSettings _themeSettings = ThemeSettings.defaultTheme;

  ThemeSettings get themeSettings => _themeSettings;

  ThemeProvider() {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeJson = prefs.getString('theme_settings');
    
    if (themeJson != null) {
      _themeSettings = ThemeSettings.fromJson(json.decode(themeJson));
      notifyListeners();
    }
  }

  Future<void> updateThemeSettings(ThemeSettings settings) async {
    _themeSettings = settings;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_settings', json.encode(settings.toJson()));
  }

  Future<void> resetToDefault() async {
    _themeSettings = ThemeSettings.defaultTheme;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme_settings');
  }

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: _themeSettings.primary,
      scaffoldBackgroundColor: _themeSettings.background,
      
      appBarTheme: AppBarTheme(
        backgroundColor: _themeSettings.primary,
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _themeSettings.surface,
        selectedItemColor: _themeSettings.iconActive,
        unselectedItemColor: _themeSettings.iconInactive,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      iconTheme: IconThemeData(
        color: _themeSettings.iconInactive,
      ),
      
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _themeSettings.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: _themeSettings.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: _themeSettings.textSecondary,
        ),
      ),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: _themeSettings.primary,
        primary: _themeSettings.primary,
        secondary: _themeSettings.accent,
        surface: _themeSettings.surface,
        error: _themeSettings.error,
      ),
    );
  }
}