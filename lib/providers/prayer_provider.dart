import 'package:flutter/foundation.dart';
import 'package:ramadan_planner/models/prayer_time.dart';
import 'package:ramadan_planner/services/database_service.dart';
import 'package:ramadan_planner/services/prayer_time_service.dart';

class PrayerProvider with ChangeNotifier {
  List<PrayerTime> _prayerTimes = [];
  String? _error;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  
  List<PrayerTime> get prayerTimes => [..._prayerTimes];
  String? get error => _error;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  
  // Load prayer times for a specific date and user
  Future<void> loadPrayerTimes(int userId, {DateTime? date}) async {
    _isLoading = true;
    _error = null;
    
    if (date != null) {
      _selectedDate = date;
    }
    
    notifyListeners();
    
    try {
      final dbService = DatabaseService();
      
      // Try to get saved prayer times from the database first
      final savedPrayerTimes = await dbService.getPrayerTimesByUserId(userId, _selectedDate);
      
      if (savedPrayerTimes.isNotEmpty) {
        _prayerTimes = savedPrayerTimes;
      } else {
        // If no saved prayer times, get from the prayer time service
        final prayerTimeService = PrayerTimeService();
        _prayerTimes = prayerTimeService.getPrayerTimeObjects(_selectedDate, userId);
        
        // Save these prayer times to the database
        for (final prayerTime in _prayerTimes) {
          await dbService.createPrayerTime(prayerTime);
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update a prayer time's completed status
  Future<bool> togglePrayerCompletion(PrayerTime prayerTime) async {
    try {
      if (prayerTime.id == null) {
        _error = 'Prayer time ID is required';
        notifyListeners();
        return false;
      }
      
      // Update locally first
      final index = _prayerTimes.indexWhere((p) => p.id == prayerTime.id);
      if (index < 0) {
        _error = 'Prayer time not found';
        notifyListeners();
        return false;
      }
      
      // Create a new prayer time with toggled completion
      final updatedPrayerTime = prayerTime.copyWith(
        completed: !prayerTime.completed,
      );
      
      // Update in the database
      final dbService = DatabaseService();
      final updated = await dbService.updatePrayerTime(updatedPrayerTime);
      
      if (updated != null) {
        // Update in the local list
        _prayerTimes[index] = updated;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update prayer time';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Change selected date and reload prayer times
  Future<void> changeDate(DateTime date, int userId) async {
    if (date.compareTo(_selectedDate) != 0) {
      await loadPrayerTimes(userId, date: date);
    }
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}