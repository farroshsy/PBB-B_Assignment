class PrayerTime {
  final String name;
  final String time;
  final bool completed;
  
  const PrayerTime({
    required this.name,
    required this.time,
    this.completed = false,
  });
  
  PrayerTime copyWith({
    String? name,
    String? time,
    bool? completed,
  }) {
    return PrayerTime(
      name: name ?? this.name,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }
  
  /// Check if this prayer time is active (within 15 minutes of current time)
  bool isActive(DateTime now) {
    // Parse prayer time (HH:MM)
    final parts = time.split(':');
    if (parts.length != 2) return false;
    
    final prayerHour = int.tryParse(parts[0]);
    final prayerMinute = int.tryParse(parts[1]);
    
    if (prayerHour == null || prayerMinute == null) return false;
    
    // Create DateTime for prayer time today
    final prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      prayerHour,
      prayerMinute,
    );
    
    // Calculate difference in minutes
    final difference = now.difference(prayerDateTime).inMinutes.abs();
    
    // Active if within 15 minutes before or after
    return difference <= 15;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
      'completed': completed,
    };
  }
  
  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      name: json['name'] as String,
      time: json['time'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }
}