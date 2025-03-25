import 'package:flutter/material.dart';
import 'package:ramadan_planner/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_planner/providers/user_provider.dart';
import 'package:ramadan_planner/widgets/islamic_pattern.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      final success = await userProvider.createUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        location: _locationController.text.trim().isNotEmpty 
            ? _locationController.text.trim() 
            : 'Surabaya, Indonesia', // Default to Surabaya if not specified
      );
      
      if (!success && mounted) {
        setState(() {
          _errorMessage = userProvider.error ?? 'Failed to create user';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background pattern
          const IslamicPattern(opacity: 0.1),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    
                    // App logo or icon
                    Image.asset(
                      'assets/images/placeholder.svg',
                      height: 100,
                      width: 100,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // App name
                    Text(
                      AppConstants.appName,
                      style: const TextStyle(
                        fontFamily: AppConstants.primaryFont,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Subtitle
                    const Text(
                      'Your personal Ramadan companion',
                      style: TextStyle(
                        fontFamily: AppConstants.primaryFont,
                        fontSize: 16,
                        color: AppConstants.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Registration form
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontFamily: AppConstants.primaryFont,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Name field
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 15),
                              
                              // Email field
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 15),
                              
                              // Location field (optional)
                              TextFormField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  labelText: 'Location (Optional)',
                                  hintText: 'Default: Surabaya, Indonesia',
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                              ),
                              
                              const SizedBox(height: 25),
                              
                              // Error message
                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontFamily: AppConstants.primaryFont,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              
                              // Submit button
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: AppConstants.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Get Started',
                                        style: TextStyle(
                                          fontFamily: AppConstants.primaryFont,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}