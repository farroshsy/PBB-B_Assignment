import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/db_helper.dart';
import '../utils/constants.dart';

class AuthService {
  // Register a new user
  Future<User> register(String name, String email, String password) async {
    try {
      // Hash the password
      final hashedPassword = _hashPassword(password);
      
      // Check if user already exists
      final existingUsers = await DbHelper.query(
        'SELECT * FROM users WHERE email = @email',
        {'email': email}
      );
      
      if (existingUsers.isNotEmpty) {
        throw Exception('User with this email already exists');
      }
      
      // Insert new user
      final userData = await DbHelper.insert(
        'users', 
        {
          'name': name,
          'email': email,
          'password': hashedPassword
        },
        'id'
      );
      
      if (userData == null) {
        throw Exception('Failed to create user');
      }
      
      // Generate token
      final token = _generateToken(userData['id'] as int, email);
      
      // Save token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.authTokenKey, token);
      await prefs.setInt(AppConstants.userIdKey, userData['id'] as int);
      await prefs.setString(AppConstants.userNameKey, name);
      await prefs.setString(AppConstants.userEmailKey, email);
      
      // Return user with token
      return User(
        id: userData['id'] as int,
        name: name,
        email: email,
        token: token,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  // Login an existing user
  Future<User> login(String email, String password) async {
    try {
      // Hash the password
      final hashedPassword = _hashPassword(password);
      
      // Check credentials
      final users = await DbHelper.query(
        'SELECT * FROM users WHERE email = @email AND password = @password',
        {
          'email': email,
          'password': hashedPassword
        }
      );
      
      if (users.isEmpty) {
        throw Exception('Invalid email or password');
      }
      
      final userData = users.first;
      
      // Generate token
      final token = _generateToken(userData['id'] as int, email);
      
      // Save token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.authTokenKey, token);
      await prefs.setInt(AppConstants.userIdKey, userData['id'] as int);
      await prefs.setString(AppConstants.userNameKey, userData['name'] as String);
      await prefs.setString(AppConstants.userEmailKey, email);
      
      // Return user with token
      return User(
        id: userData['id'] as int,
        name: userData['name'] as String,
        email: email,
        token: token,
        createdAt: DateTime.parse(userData['created_at'] as String),
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  // Logout current user
  Future<void> logout() async {
    try {
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.authTokenKey);
      await prefs.remove(AppConstants.userIdKey);
      await prefs.remove(AppConstants.userNameKey);
      await prefs.remove(AppConstants.userEmailKey);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
  
  // Check if user is logged in
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.authTokenKey);
      final userId = prefs.getInt(AppConstants.userIdKey);
      final userName = prefs.getString(AppConstants.userNameKey);
      final userEmail = prefs.getString(AppConstants.userEmailKey);
      
      if (token == null || userId == null || userName == null || userEmail == null) {
        return null;
      }
      
      // Validate token by checking if user exists
      final users = await DbHelper.query(
        'SELECT * FROM users WHERE id = @id',
        {'id': userId}
      );
      
      if (users.isEmpty) {
        await logout();
        return null;
      }
      
      return User(
        id: userId,
        name: userName,
        email: userEmail,
        token: token,
        createdAt: DateTime.parse(users.first['created_at'] as String),
      );
    } catch (e) {
      return null;
    }
  }
  
  // Hash password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Generate a token
  String _generateToken(int userId, String email) {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final data = '$userId:$email:$now';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
