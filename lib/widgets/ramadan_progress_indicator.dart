import 'package:flutter/material.dart';
import 'package:ramadan_planner/utils/constants.dart';

/// An interactive widget that displays Ramadan progress through the month
/// with day highlighting and selection
class RamadanProgressIndicator extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final Function(int) onDaySelected;
  final int? selectedDay;

  const RamadanProgressIndicator({
    super.key,
    required this.currentDay,
    required this.totalDays,
    required this.onDaySelected,
    this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ramadan Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Day $currentDay of Ramadan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          
          // Progress bar
          LinearProgressIndicator(
            value: currentDay / totalDays,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.secondaryColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const SizedBox(height: 16),
          
          // Day indicator
          _buildDayGrid(),
        ],
      ),
    );
  }

  Widget _buildDayGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: totalDays,
      itemBuilder: (context, index) {
        final dayNumber = index + 1;
        final isToday = dayNumber == currentDay;
        final isSelected = selectedDay != null && dayNumber == selectedDay;
        final isPast = dayNumber < currentDay;
        
        return GestureDetector(
          onTap: () => onDaySelected(dayNumber),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppConstants.secondaryColor
                  : isToday
                      ? AppConstants.primaryColor
                      : isPast
                          ? Colors.grey.shade200
                          : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected || isToday
                    ? Colors.transparent
                    : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: isSelected || isToday
                  ? [
                      BoxShadow(
                        color: (isSelected ? AppConstants.secondaryColor : AppConstants.primaryColor)
                            .withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isToday || isSelected
                      ? Colors.white
                      : isPast
                          ? Colors.grey.shade600
                          : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}