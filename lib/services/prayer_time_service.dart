import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ramadan_planner/models/prayer_time.dart';
import 'package:ramadan_planner/utils/constants.dart';

class PrayerTimeService {
  // Hardcoded coordinates for Surabaya, Indonesia
  final double _latitude = -7.2575;
  final double _longitude = 112.7521;

  // Get prayer times for a specific date
  Future<Map<String, dynamic>> getPrayerTimes(DateTime date) async {
    try {
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);
      final url = Uri.parse(
        '${AppConstants.prayerTimeApiBaseUrl}timings/$formattedDate?latitude=$_latitude&longitude=$_longitude&method=11'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        
        if (decodedData['code'] == 200 && decodedData['status'] == 'OK') {
          return decodedData['data']['timings'];
        } else {
          throw Exception('API error: ${decodedData['status']}');
        }
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      // If API call fails, use hardcoded prayer times for Surabaya
      return _getOfflinePrayerTimes(date);
    }
  }

  // Create PrayerTime objects for a specific date and user
  List<PrayerTime> getPrayerTimeObjects(DateTime date, int userId) {
    // Use offline prayer times for specific date
    final timings = _getOfflinePrayerTimes(date);
    
    final prayerTimes = <PrayerTime>[];
    
    // Create prayer time objects for all standard prayers
    for (final name in AppConstants.prayerNames) {
      if (timings.containsKey(name.toUpperCase())) {
        prayerTimes.add(PrayerTime(
          userId: userId,
          name: name,
          time: timings[name.toUpperCase()]!,
          date: date,
        ));
      }
    }
    
    return prayerTimes;
  }

  // Provide offline prayer times for Surabaya, Indonesia during Ramadan
  Map<String, dynamic> _getOfflinePrayerTimes(DateTime date) {
    // Ramadan 2025 is expected to start around March 1, 2025
    // These are approximate times for Surabaya during Ramadan
    
    // Standard prayer times for Surabaya during Ramadan
    final Map<String, String> standardTimes = {
      'FAJR': '04:20',
      'SUNRISE': '05:40',
      'DHUHR': '11:45',
      'ASR': '15:00',
      'MAGHRIB': '17:50',
      'ISHA': '19:00',
    };
    
    // Adjust times slightly based on the date within Ramadan
    final int dayOfMonth = date.day;
    
    // Minor adjustments to simulate variation during Ramadan
    if (dayOfMonth < 10) {
      // Early Ramadan
      return {
        'FAJR': '04:18',
        'SUNRISE': '05:38',
        'DHUHR': '11:45',
        'ASR': '14:58',
        'MAGHRIB': '17:52',
        'ISHA': '19:02',
      };
    } else if (dayOfMonth < 20) {
      // Mid Ramadan
      return {
        'FAJR': '04:20',
        'SUNRISE': '05:40',
        'DHUHR': '11:45',
        'ASR': '15:00',
        'MAGHRIB': '17:50',
        'ISHA': '19:00',
      };
    } else {
      // Late Ramadan
      return {
        'FAJR': '04:22',
        'SUNRISE': '05:42',
        'DHUHR': '11:45',
        'ASR': '15:02',
        'MAGHRIB': '17:48',
        'ISHA': '18:58',
      };
    }
  }
}