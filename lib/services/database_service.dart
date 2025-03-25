import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ramadan_planner/models/activity.dart';
import 'package:ramadan_planner/models/prayer_time.dart';
import 'package:ramadan_planner/models/user.dart';
import 'package:ramadan_planner/utils/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  bool _isInitialized = false;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> initDb() async {
    if (_isInitialized) {
      return;
    }

    try {
      await Supabase.initialize(
        url: const String.fromEnvironment('SUPABASE_URL', 
            defaultValue: 'https://xxxxxxxxxxxxxxxxxxxx.supabase.co'),
        anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY',
            defaultValue: 'your-anon-key'),
      );
      
      _isInitialized = true;
    } catch (e) {
      print('Error initializing Supabase: $e');
      rethrow;
    }
  }

  SupabaseClient get _client => Supabase.instance.client;

  // --- User methods ---
  
  // Create user
  Future<User?> createUser(User user) async {
    try {
      final response = await _client.from(AppConstants.userTable).insert({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'location': user.location,
        'is_dark_mode_enabled': user.isDarkModeEnabled,
        'is_notifications_enabled': user.isNotificationsEnabled,
        'created_at': user.createdAt.toIso8601String(),
        'last_login_at': user.lastLoginAt?.toIso8601String(),
      }).select().single();
      
      return User.fromMap(response);
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }
  
  // Get user by ID
  Future<User?> getUserById(int id) async {
    try {
      final response = await _client
          .from(AppConstants.userTable)
          .select()
          .eq('id', id)
          .single();
      
      return User.fromMap(response);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }
  
  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _client
          .from(AppConstants.userTable)
          .select()
          .eq('email', email)
          .single();
      
      return User.fromMap(response);
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }
  
  // Get last logged in user
  Future<User?> getLastLoggedInUser() async {
    try {
      final response = await _client
          .from(AppConstants.userTable)
          .select()
          .order('last_login_at', ascending: false)
          .limit(1)
          .single();
      
      return User.fromMap(response);
    } catch (e) {
      print('Error getting last logged in user: $e');
      return null;
    }
  }
  
  // Update user
  Future<User?> updateUser(User user) async {
    try {
      if (user.id == null) {
        return null;
      }
      
      final response = await _client
          .from(AppConstants.userTable)
          .update({
            'name': user.name,
            'email': user.email,
            'location': user.location,
            'is_dark_mode_enabled': user.isDarkModeEnabled,
            'is_notifications_enabled': user.isNotificationsEnabled,
            'last_login_at': user.lastLoginAt?.toIso8601String(),
          })
          .eq('id', user.id)
          .select()
          .single();
      
      return User.fromMap(response);
    } catch (e) {
      print('Error updating user: $e');
      return null;
    }
  }
  
  // Delete user
  Future<bool> deleteUser(int id) async {
    try {
      await _client
          .from(AppConstants.userTable)
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
  
  // --- Activity methods ---
  
  // Create activity
  Future<Activity?> createActivity(Activity activity) async {
    try {
      final response = await _client.from(AppConstants.activityTable).insert({
        'user_id': activity.userId,
        'title': activity.title,
        'description': activity.description,
        'type': activity.type,
        'date': activity.date.toIso8601String(),
        'start_time': activity.startTime,
        'end_time': activity.endTime,
        'priority': activity.priority,
        'completed': activity.completed,
        'created_at': activity.createdAt.toIso8601String(),
      }).select().single();
      
      return Activity.fromMap(response);
    } catch (e) {
      print('Error creating activity: $e');
      return null;
    }
  }
  
  // Get activities by user ID
  Future<List<Activity>> getActivitiesByUserId(int userId, [DateTime? date]) async {
    try {
      var query = _client
          .from(AppConstants.activityTable)
          .select()
          .eq('user_id', userId);
      
      if (date != null) {
        query = query.eq('date', date.toIso8601String());
      }
      
      final response = await query
          .order('date')
          .order('start_time');
      
      return response.map((data) => Activity.fromMap(data)).toList();
    } catch (e) {
      print('Error getting activities by user ID: $e');
      return [];
    }
  }
  
  // Get activity by ID
  Future<Activity?> getActivityById(int id) async {
    try {
      final response = await _client
          .from(AppConstants.activityTable)
          .select()
          .eq('id', id)
          .single();
      
      return Activity.fromMap(response);
    } catch (e) {
      print('Error getting activity by ID: $e');
      return null;
    }
  }
  
  // Update activity
  Future<Activity?> updateActivity(Activity activity) async {
    try {
      if (activity.id == null) {
        return null;
      }
      
      final response = await _client
          .from(AppConstants.activityTable)
          .update({
            'title': activity.title,
            'description': activity.description,
            'type': activity.type,
            'date': activity.date.toIso8601String(),
            'start_time': activity.startTime,
            'end_time': activity.endTime,
            'priority': activity.priority,
            'completed': activity.completed,
          })
          .eq('id', activity.id)
          .select()
          .single();
      
      return Activity.fromMap(response);
    } catch (e) {
      print('Error updating activity: $e');
      return null;
    }
  }
  
  // Delete activity
  Future<bool> deleteActivity(int id) async {
    try {
      await _client
          .from(AppConstants.activityTable)
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      print('Error deleting activity: $e');
      return false;
    }
  }
  
  // --- Prayer time methods ---
  
  // Create prayer time
  Future<PrayerTime?> createPrayerTime(PrayerTime prayerTime) async {
    try {
      final response = await _client.from(AppConstants.prayerTimeTable).insert({
        'user_id': prayerTime.userId,
        'name': prayerTime.name,
        'time': prayerTime.time,
        'date': prayerTime.date.toIso8601String(),
        'completed': prayerTime.completed,
      }).select().single();
      
      return PrayerTime.fromMap(response);
    } catch (e) {
      print('Error creating prayer time: $e');
      return null;
    }
  }
  
  // Get prayer times by user ID
  Future<List<PrayerTime>> getPrayerTimesByUserId(int userId, DateTime date) async {
    try {
      final response = await _client
          .from(AppConstants.prayerTimeTable)
          .select()
          .eq('user_id', userId)
          .eq('date', date.toIso8601String())
          .order('time');
      
      return response.map((data) => PrayerTime.fromMap(data)).toList();
    } catch (e) {
      print('Error getting prayer times by user ID: $e');
      return [];
    }
  }
  
  // Update prayer time
  Future<PrayerTime?> updatePrayerTime(PrayerTime prayerTime) async {
    try {
      if (prayerTime.id == null) {
        return null;
      }
      
      final response = await _client
          .from(AppConstants.prayerTimeTable)
          .update({
            'name': prayerTime.name,
            'time': prayerTime.time,
            'date': prayerTime.date.toIso8601String(),
            'completed': prayerTime.completed,
          })
          .eq('id', prayerTime.id)
          .select()
          .single();
      
      return PrayerTime.fromMap(response);
    } catch (e) {
      print('Error updating prayer time: $e');
      return null;
    }
  }
  
  // Delete prayer time
  Future<bool> deletePrayerTime(int id) async {
    try {
      await _client
          .from(AppConstants.prayerTimeTable)
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      print('Error deleting prayer time: $e');
      return false;
    }
  }
}