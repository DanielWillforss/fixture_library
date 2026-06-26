import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE53935), // Main red
    secondary: Color(0xFFFF5252), // Accent red
    surface: Color(0xFF1E1E1E), // Cards
    surfaceContainer: Color(0xFF1E1E1E),
    onSurface: Colors.white,
    onPrimary: Colors.white,
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),
  canvasColor: const Color(0xFF121212),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFE53935),
    foregroundColor: Color(0xFF1E1E1E),
    elevation: 0,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: Color(0x33E53935), // subtle red border
      ),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  ),

  listTileTheme: ListTileThemeData(
    tileColor: const Color(0xFF1E1E1E),
    iconColor: const Color(0xFFE53935),
    textColor: Colors.white,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: const Color(0x33E53935), width: 1.0),
    ),
  ),

  dividerTheme: const DividerThemeData(color: Color(0xFF333333), thickness: 1),

  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE53935),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
