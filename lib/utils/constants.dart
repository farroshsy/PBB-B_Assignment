import 'package:flutter/material.dart';

/// Application-wide constants class
class AppConstants {
  // App information
  static const String appName = 'Ramadan Planner';
  static const String appVersion = '1.0.0';
  
  // API endpoints
  static const String baseApiUrl = 'https://api.aladhan.com/v1/';
  static const String prayerTimeEndpoint = 'timingsByCity';
  
  // Default location for prayer times
  static const String defaultCity = 'Surabaya';
  static const String defaultCountry = 'Indonesia';
  
  // Color scheme 
  static const Color primaryColor = Color(0xFF00796B); // Deep Teal
  static const Color secondaryColor = Color(0xFFFFC107); // Gold
  static const Color backgroundColor = Color(0xFFF8F9FA); // Off White
  static const Color textColor = Color(0xFF263238); // Dark Slate
  static const Color accentColor = Color(0xFF8D6E63); // Warm Brown
  
  // Fonts
  static const String primaryFont = 'Roboto';
  static const String arabicFont = 'Amiri';
  
  // Ramadan specific
  static const int ramadanDays = 30;
  static const int hijriYearOffset = 1445; // Hijri calendar year as of 2024
  
  // Prayer names in English and Arabic
  static const Map<String, String> prayerNames = {
    'fajr': 'الفجر',
    'sunrise': 'الشروق',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
  };
  
  // Activity types
  static const List<String> activityTypes = [
    'prayer',
    'spiritual',
    'food',
    'charity',
    'social',
    'other',
  ];
  
  // Typography
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );
  
  // Error messages
  static const String errorPrayerTime = 'Unable to load prayer times. Please check your connection.';
  static const String errorSaving = 'Failed to save data. Please try again.';
  
  // Success messages
  static const String successSaving = 'Data saved successfully.';
  
  // App routes
  static const String homeRoute = '/';
  static const String settingsRoute = '/settings';
  static const String duaRoute = '/duas';
  static const String activityRoute = '/activities';
}