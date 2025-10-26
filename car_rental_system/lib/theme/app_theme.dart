import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFFDF0000),       // Principal (botones primarios, FAB)
      onPrimary: Colors.white,                // Texto sobre botones primarios
      secondary: const Color(0xFF136E13),     // Acciones secundarias (confirmaciones, disponibilidad)
      onSecondary: Colors.white,
      tertiary: const Color(0xFFD4A109),      // Acento (advertencias, indicadores)
      onTertiary: Colors.black,
      surface: const Color(0xFFEFEEEE),       // Fondo base de la app
      onSurface: const Color(0xFF181308),     // Texto principal
      background: const Color(0xFFEFEEEE),
      onBackground: const Color(0xFF181308),
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFEFEEEE),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF181308),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDF0000), 
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFDF0000),  
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF181308), 
      selectedItemColor: const Color(0xFFD4A109), 
      unselectedItemColor: const Color(0xFF778171), 
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF181308)),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
