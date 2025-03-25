import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../widgets/islamic_app_bar.dart';
import '../widgets/islamic_button.dart';
import '../widgets/islamic_text_field.dart';
import '../widgets/islamic_patterns.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.register(name, email, password);
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'Create Account',
        centerTitle: true,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Islamic pattern background
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: IslamicPatterns.geometricPattern(),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome text
                    Center(
                      child: Text(
                        'Join Ramadan Planner',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Center(
                      child: Text(
                        'Create an account to start your blessed journey',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Registration form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name field
                          IslamicTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                            validator: Validators.validateName,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Email field
                          IslamicTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Enter your email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Password field
                          IslamicTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Create a password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            validator: Validators.validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppTheme.accentColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Confirm password field
                          IslamicTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: 'Confirm your password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppTheme.accentColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Error message
                          if (authProvider.errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      authProvider.errorMessage!,
                                      style: TextStyle(color: Colors.red.shade700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          const SizedBox(height: 24),
                          
                          // Terms and conditions
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 14,
                                color: AppTheme.accentColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'By signing up, you agree to our Terms of Service and Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Register button
                          IslamicButton(
                            text: 'Create Account',
                            isLoading: authProvider.isLoading,
                            onPressed: _register,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: AppTheme.textColor.withOpacity(0.7),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
