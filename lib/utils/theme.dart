import 'package:flutter/material.dart';
import 'package:ramadan_planner/utils/constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        background: AppConstants.backgroundColor,
      ),
      fontFamily: AppConstants.primaryFont,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
        ),
        bodySmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppConstants.textColor,
        ),
      ),
    );
  }
  
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        background: const Color(0xFF121212),
        brightness: Brightness.dark,
      ),
      fontFamily: AppConstants.primaryFont,
      scaffoldBackgroundColor: const Color(0xFF121212),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Colors.white,
        ),
      ),
    );
  }
}