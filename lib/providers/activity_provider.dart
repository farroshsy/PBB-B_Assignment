import 'package:flutter/foundation.dart';
import 'package:ramadan_planner/models/activity.dart';
import 'package:ramadan_planner/services/database_service.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [];
  String? _error;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  
  List<Activity> get activities => [..._activities];
  String? get error => _error;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  
  // Load activities for a specific date and user
  Future<void> loadActivities(int userId, {DateTime? date}) async {
    _isLoading = true;
    _error = null;
    
    if (date != null) {
      _selectedDate = date;
    }
    
    notifyListeners();
    
    try {
      final dbService = DatabaseService();
      _activities = await dbService.getActivitiesByUserId(userId, _selectedDate);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Create a new activity
  Future<bool> createActivity(Activity activity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final dbService = DatabaseService();
      final createdActivity = await dbService.createActivity(activity);
      
      if (createdActivity != null) {
        _activities.add(createdActivity);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create activity';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Update an activity
  Future<bool> updateActivity(Activity activity) async {
    try {
      if (activity.id == null) {
        _error = 'Activity ID is required';
        notifyListeners();
        return false;
      }
      
      _isLoading = true;
      notifyListeners();
      
      final dbService = DatabaseService();
      final updatedActivity = await dbService.updateActivity(activity);
      
      if (updatedActivity != null) {
        // Update in local list
        final index = _activities.indexWhere((a) => a.id == activity.id);
        if (index >= 0) {
          _activities[index] = updatedActivity;
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update activity';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Toggle activity completion status
  Future<bool> toggleActivityCompletion(Activity activity) async {
    try {
      // Create a new activity with toggled completion
      final updatedActivity = activity.copyWith(
        completed: !activity.completed,
      );
      
      return await updateActivity(updatedActivity);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Delete an activity
  Future<bool> deleteActivity(int id) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final dbService = DatabaseService();
      final success = await dbService.deleteActivity(id);
      
      if (success) {
        // Remove from local list
        _activities.removeWhere((a) => a.id == id);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to delete activity';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Change selected date and reload activities
  Future<void> changeDate(DateTime date, int userId) async {
    if (date.compareTo(_selectedDate) != 0) {
      await loadActivities(userId, date: date);
    }
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}