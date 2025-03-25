import 'package:flutter/foundation.dart';
import 'package:ramadan_planner/models/user.dart';
import 'package:ramadan_planner/services/database_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  String? _error;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  
  User? get currentUser => _currentUser;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  
  // Check if user is already logged in (e.g., from saved preferences)
  Future<bool> checkLoggedInUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final dbService = DatabaseService();
      final lastLoggedInUser = await dbService.getLastLoggedInUser();
      
      if (lastLoggedInUser != null) {
        _currentUser = lastLoggedInUser;
        _isLoggedIn = true;
      } else {
        _currentUser = null;
        _isLoggedIn = false;
      }
      
      _isLoading = false;
      notifyListeners();
      return _isLoggedIn;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }
  
  // Register a new user
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final dbService = DatabaseService();
      
      // Check if email already exists
      final existingUser = await dbService.getUserByEmail(email);
      if (existingUser != null) {
        _error = 'Email already registered';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Create new user
      final newUser = User(
        name: name,
        email: email,
        password: password, // In a real app, hash this password
        location: 'Surabaya, Indonesia', // Default location for prayer times
        isDarkModeEnabled: false,
        isNotificationsEnabled: true,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      final createdUser = await dbService.createUser(newUser);
      
      if (createdUser != null) {
        _currentUser = createdUser;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create user';
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
  
  // Login existing user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final dbService = DatabaseService();
      final user = await dbService.getUserByEmail(email);
      
      if (user == null) {
        _error = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Simple password check (in a real app, verify against hashed password)
      if (user.password != password) {
        _error = 'Invalid password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Update last login time
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      final updated = await dbService.updateUser(updatedUser);
      
      if (updated != null) {
        _currentUser = updated;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update user login time';
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
  
  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? location,
    bool? isDarkModeEnabled,
    bool? isNotificationsEnabled,
  }) async {
    if (_currentUser == null) {
      _error = 'No user logged in';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final updatedUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        location: location ?? _currentUser!.location,
        isDarkModeEnabled: isDarkModeEnabled ?? _currentUser!.isDarkModeEnabled,
        isNotificationsEnabled: isNotificationsEnabled ?? _currentUser!.isNotificationsEnabled,
      );
      
      final dbService = DatabaseService();
      final updated = await dbService.updateUser(updatedUser);
      
      if (updated != null) {
        _currentUser = updated;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update profile';
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
  
  // Toggle dark mode
  Future<bool> toggleDarkMode() async {
    return await updateProfile(isDarkModeEnabled: !(_currentUser?.isDarkModeEnabled ?? false));
  }
  
  // Toggle notifications
  Future<bool> toggleNotifications() async {
    return await updateProfile(isNotificationsEnabled: !(_currentUser?.isNotificationsEnabled ?? true));
  }
  
  // Logout user
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}