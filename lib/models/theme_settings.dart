import 'package:flutter/material.dart';

class ThemeSettings {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color iconActive;
  final Color iconInactive;
  final Color success;
  final Color error;
  final Color warning;
  final Color divider;

  const ThemeSettings({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.iconActive,
    required this.iconInactive,
    required this.success,
    required this.error,
    required this.warning,
    required this.divider,
  });

  static const ThemeSettings defaultTheme = ThemeSettings(
    primary: Color(0xFF2196F3),
    primaryDark: Color(0xFF1976D2),
    primaryLight: Color(0xFF64B5F6),
    accent: Color(0xFF03A9F4),
    background: Color(0xFFF5F5F5),
    surface: Colors.white,
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF757575),
    textHint: Color(0xFF9E9E9E),
    iconActive: Color(0xFF2196F3),
    iconInactive: Color(0xFF9E9E9E),
    success: Color(0xFF4CAF50),
    error: Color(0xFFF44336),
    warning: Color(0xFFFF9800),
    divider: Color(0xFFBDBDBD),
  );

  Map<String, dynamic> toJson() {
    return {
      'primary': primary.value,
      'primaryDark': primaryDark.value,
      'primaryLight': primaryLight.value,
      'accent': accent.value,
      'background': background.value,
      'surface': surface.value,
      'textPrimary': textPrimary.value,
      'textSecondary': textSecondary.value,
      'textHint': textHint.value,
      'iconActive': iconActive.value,
      'iconInactive': iconInactive.value,
      'success': success.value,
      'error': error.value,
      'warning': warning.value,
      'divider': divider.value,
    };
  }

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      primary: Color(json['primary'] ?? defaultTheme.primary.value),
      primaryDark: Color(json['primaryDark'] ?? defaultTheme.primaryDark.value),
      primaryLight: Color(json['primaryLight'] ?? defaultTheme.primaryLight.value),
      accent: Color(json['accent'] ?? defaultTheme.accent.value),
      background: Color(json['background'] ?? defaultTheme.background.value),
      surface: Color(json['surface'] ?? defaultTheme.surface.value),
      textPrimary: Color(json['textPrimary'] ?? defaultTheme.textPrimary.value),
      textSecondary: Color(json['textSecondary'] ?? defaultTheme.textSecondary.value),
      textHint: Color(json['textHint'] ?? defaultTheme.textHint.value),
      iconActive: Color(json['iconActive'] ?? defaultTheme.iconActive.value),
      iconInactive: Color(json['iconInactive'] ?? defaultTheme.iconInactive.value),
      success: Color(json['success'] ?? defaultTheme.success.value),
      error: Color(json['error'] ?? defaultTheme.error.value),
      warning: Color(json['warning'] ?? defaultTheme.warning.value),
      divider: Color(json['divider'] ?? defaultTheme.divider.value),
    );
  }

  ThemeSettings copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? accent,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? iconActive,
    Color? iconInactive,
    Color? success,
    Color? error,
    Color? warning,
    Color? divider,
  }) {
    return ThemeSettings(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      iconActive: iconActive ?? this.iconActive,
      iconInactive: iconInactive ?? this.iconInactive,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      divider: divider ?? this.divider,
    );
  }
}