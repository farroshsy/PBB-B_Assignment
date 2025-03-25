import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }
  
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM d, y · h:mm a').format(dateTime);
  }
  
  static String getWeekday(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
  
  static String getShortWeekday(DateTime date) {
    return DateFormat('E').format(date);
  }
  
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }
  
  static String getShortMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }
  
  static String formatTimeOnly(DateTime time) {
    return DateFormat('h:mm').format(time);
  }
  
  static String formatAmPm(DateTime time) {
    return DateFormat('a').format(time);
  }
  
  // Format for prayer times display
  static String formatPrayerTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
  
  // Format for Ramadan day display
  static String formatRamadanDay(int day) {
    return 'Day $day';
  }
  
  // Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  // Get relative time (today, yesterday, etc.)
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Today · ${formatTime(dateTime)}';
    } else if (date == yesterday) {
      return 'Yesterday · ${formatTime(dateTime)}';
    } else if (date == tomorrow) {
      return 'Tomorrow · ${formatTime(dateTime)}';
    } else {
      return formatDateTime(dateTime);
    }
  }
}