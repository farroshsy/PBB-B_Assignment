import 'package:flutter/material.dart';
import 'package:ramadan_planner/models/prayer_time.dart';
import 'package:ramadan_planner/utils/constants.dart';

/// Interactive widget for displaying a prayer time with completion toggle
class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayerTime;
  final VoidCallback onToggleCompletion;
  final bool isNextPrayer;

  const PrayerTimeCard({
    super.key,
    required this.prayerTime,
    required this.onToggleCompletion,
    this.isNextPrayer = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if this prayer is active (within 15 mins of current time)
    final isActive = prayerTime.isActive(DateTime.now());
    
    // Set card color based on status
    Color cardColor = Colors.white;
    Color textColor = Colors.black87;
    Color timeColor = AppConstants.primaryColor;
    
    if (isNextPrayer) {
      cardColor = AppConstants.secondaryColor.withOpacity(0.2);
      timeColor = AppConstants.secondaryColor;
    } else if (isActive) {
      cardColor = AppConstants.secondaryColor;
      textColor = Colors.black87;
      timeColor = AppConstants.primaryColor;
    } else if (prayerTime.completed) {
      cardColor = Colors.grey.shade100;
      textColor = Colors.grey;
      timeColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: isActive ? 4 : 1,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isNextPrayer
              ? BorderSide(color: AppConstants.secondaryColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onToggleCompletion,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Prayer icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getPrayerIcon(prayerTime.name),
                        color: timeColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prayerTime.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prayerTime.time,
                          style: TextStyle(
                            fontSize: 14,
                            color: timeColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Completion checkbox
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: prayerTime.completed
                        ? AppConstants.primaryColor
                        : Colors.white,
                    border: Border.all(
                      color: prayerTime.completed
                          ? AppConstants.primaryColor
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: prayerTime.completed
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.sunny_snowing;
      case 'maghrib':
        return Icons.nightlight_round;
      case 'isha':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }
}