import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../utils/theme.dart';
import '../widgets/islamic_app_bar.dart';
import '../widgets/islamic_button.dart';
import '../widgets/islamic_patterns.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: const IslamicAppBar(
        title: 'Profile',
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
          authProvider.currentUser == null
              ? _buildNotAuthenticated(context)
              : _buildAuthenticated(context, authProvider),
        ],
      ),
    );
  }

  Widget _buildNotAuthenticated(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Not Logged In',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please log in to access your profile',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: IslamicButton(
              text: 'Log In',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticated(BuildContext context, AuthProvider authProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile header
            _buildProfileHeader(authProvider),
            
            const SizedBox(height: 24),
            
            // App Settings
            _buildSettingsSection(),
            
            const SizedBox(height: 24),
            
            // App Info
            _buildAppInfoSection(),
            
            const SizedBox(height: 24),
            
            // Logout button
            SizedBox(
              width: double.infinity,
              child: IslamicButton(
                text: 'Logout',
                isOutlined: true,
                outlineColor: Colors.red.shade300,
                textColor: Colors.red.shade700,
                onPressed: () async {
                  await authProvider.logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    authProvider.currentUser!.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.currentUser!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.currentUser!.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Ramadan User',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement edit profile functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile feature coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit, size: 16),
                SizedBox(width: 8),
                Text('Edit Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: AppTheme.headingStyle,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Notifications'),
                subtitle: const Text('Enable prayer time notifications'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.dark_mode_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                trailing: Switch(
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dark mode will be available in future updates!'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Location Services'),
                subtitle: const Text('Use location for prayer times'),
                trailing: Switch(
                  value: _locationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _locationEnabled = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: AppTheme.headingStyle,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('App Version'),
                subtitle: const Text(AppConstants.appVersion),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implement privacy policy screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy policy will be available soon!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implement help & support screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & Support will be available soon!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.rate_review_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Rate App'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implement app rating functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rating feature will be available soon!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
