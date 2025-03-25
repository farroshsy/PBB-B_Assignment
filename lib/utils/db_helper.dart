import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ramadan_planner/utils/constants.dart';

class DbHelper {
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  // Initialize tables if they don't exist
  static Future<void> initializeTables() async {
    try {
      // Create users table
      await _createUsersTable();
      
      // Create prayer_times table
      await _createPrayerTimesTable();
      
      // Create ramadan_activities table
      await _createRamadanActivitiesTable();
    } catch (e) {
      print('Error initializing tables: $e');
      rethrow;
    }
  }
  
  // Create users table
  static Future<void> _createUsersTable() async {
    try {
      // Check if the table exists by trying to get one row
      await _supabase
          .from(AppConstants.userTable)
          .select()
          .limit(1);
    } catch (e) {
      // If the table doesn't exist, create it via SQL
      // Note: This is simplified and may not work in practice since Supabase
      // requires schema creation via their web interface or migrations
      print('Users table might not exist: $e');
    }
  }
  
  // Create prayer_times table
  static Future<void> _createPrayerTimesTable() async {
    try {
      // Check if the table exists by trying to get one row
      await _supabase
          .from(AppConstants.prayerTimeTable)
          .select()
          .limit(1);
    } catch (e) {
      // If the table doesn't exist, create it via SQL
      print('Prayer times table might not exist: $e');
    }
  }
  
  // Create ramadan_activities table
  static Future<void> _createRamadanActivitiesTable() async {
    try {
      // Check if the table exists by trying to get one row
      await _supabase
          .from(AppConstants.ramadanActivityTable)
          .select()
          .limit(1);
    } catch (e) {
      // If the table doesn't exist, create it via SQL
      print('Ramadan activities table might not exist: $e');
    }
  }
  
  // Create Database Schema on Supabase (for initial setup only)
  // This is a reference for manual setup in Supabase Dashboard
  // You cannot create tables through the API directly
  static String getSupabaseSchemaScript() {
    return '''
-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  location TEXT,
  timezone TEXT,
  profile_image_url TEXT,
  is_dark_mode_enabled BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create prayer_times table
CREATE TABLE IF NOT EXISTS prayer_times (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  prayer_name TEXT NOT NULL,
  time TEXT NOT NULL,
  date DATE NOT NULL,
  completed BOOLEAN DEFAULT FALSE,
  reminder_time TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create ramadan_activities table
CREATE TABLE IF NOT EXISTS ramadan_activities (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  type TEXT NOT NULL,
  description TEXT,
  time TEXT,
  date DATE NOT NULL,
  completed BOOLEAN DEFAULT FALSE,
  is_repeating BOOLEAN DEFAULT FALSE,
  repeat_pattern TEXT,
  repeat_days TEXT,
  reminder_time TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
''';
  }
}