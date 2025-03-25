import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:ramadan_planner/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryColor,
              Color(0xFF006064),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Islamic-themed loading animation
              Image.asset(
                '${AppConstants.imagePath}ramadan_logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Ramadan companion',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
              const SizedBox(height: 50),
              const SpinKitRipple(
                color: Colors.white,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}