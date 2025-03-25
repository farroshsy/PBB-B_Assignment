import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  // Constructor - check for logged in user
  AuthProvider() {
    _checkCurrentUser();
  }
  
  // Check if user is already logged in
  Future<void> _checkCurrentUser() async {
    _setLoading(true);
    
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  // Register a new user
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUser = await _authService.register(name, email, password);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Login an existing user
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUser = await _authService.login(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Logout current user
  Future<void> logout() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  // Refresh user data
  Future<void> refreshUser() async {
    if (_currentUser == null) return;
    
    _setLoading(true);
    
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
