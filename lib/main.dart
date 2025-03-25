import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_planner/providers/activity_provider.dart';
import 'package:ramadan_planner/providers/prayer_provider.dart';
import 'package:ramadan_planner/providers/user_provider.dart';
import 'package:ramadan_planner/screens/home_screen.dart';
import 'package:ramadan_planner/screens/splash_screen.dart';
import 'package:ramadan_planner/services/database_service.dart';
import 'package:ramadan_planner/utils/constants.dart';
import 'package:ramadan_planner/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize database
      final dbService = DatabaseService();
      await dbService.initDb();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error initializing app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: const SplashScreen(),
      );
    }

    if (_error != null) {
      return MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error Initializing App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    _initializeApp();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final isDarkMode = userProvider.currentUser?.isDarkModeEnabled ?? false;
          
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}