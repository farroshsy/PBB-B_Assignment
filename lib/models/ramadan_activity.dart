import 'package:flutter/material.dart';

class RamadanActivity {
  final int? id;
  final int userId;
  final String title;
  final String type; // One of the activity types from AppConstants
  final String? description;
  final TimeOfDay? time;
  final DateTime date;
  final bool completed;
  final bool isRepeating;
  final String? repeatPattern; // "daily", "specific_days"
  final List<int>? repeatDays; // If repeatPattern is "specific_days", this contains the days (1 = Monday, 7 = Sunday)
  final String? reminderTime; // Can be "15mins", "30mins", "1hour" before activity time
  final DateTime createdAt;
  final DateTime updatedAt;

  RamadanActivity({
    this.id,
    required this.userId,
    required this.title,
    required this.type,
    this.description,
    this.time,
    required this.date,
    this.completed = false,
    this.isRepeating = false,
    this.repeatPattern,
    this.repeatDays,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a RamadanActivity from a database map
  factory RamadanActivity.fromMap(Map<String, dynamic> map) {
    // Parse the stored time string (HH:mm format) to TimeOfDay if it exists
    TimeOfDay? timeOfDay;
    if (map['time'] != null) {
      final timeParts = (map['time'] as String).split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      timeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    
    // Parse the repeat days if they exist
    List<int>? repeatDaysList;
    if (map['repeat_days'] != null) {
      repeatDaysList = (map['repeat_days'] as String)
          .split(',')
          .map((day) => int.parse(day))
          .toList();
    }
    
    return RamadanActivity(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      type: map['type'],
      description: map['description'],
      time: timeOfDay,
      date: DateTime.parse(map['date']),
      completed: map['completed'] == 1,
      isRepeating: map['is_repeating'] == 1,
      repeatPattern: map['repeat_pattern'],
      repeatDays: repeatDaysList,
      reminderTime: map['reminder_time'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // Convert a RamadanActivity to a database map
  Map<String, dynamic> toMap() {
    // Format TimeOfDay as a string in HH:mm format if it exists
    String? timeString;
    if (time != null) {
      timeString = '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}';
    }
    
    // Format repeat days as a comma-separated string if they exist
    String? repeatDaysString;
    if (repeatDays != null && repeatDays!.isNotEmpty) {
      repeatDaysString = repeatDays!.join(',');
    }
    
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'type': type,
      'description': description,
      'time': timeString,
      'date': date.toIso8601String().split('T')[0], // Store just the date part
      'completed': completed ? 1 : 0,
      'is_repeating': isRepeating ? 1 : 0,
      'repeat_pattern': repeatPattern,
      'repeat_days': repeatDaysString,
      'reminder_time': reminderTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the current activity with specific fields updated
  RamadanActivity copyWith({
    int? id,
    int? userId,
    String? title,
    String? type,
    String? description,
    TimeOfDay? time,
    DateTime? date,
    bool? completed,
    bool? isRepeating,
    String? repeatPattern,
    List<int>? repeatDays,
    String? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RamadanActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      time: time ?? this.time,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      repeatDays: repeatDays ?? this.repeatDays,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    String timeStr = time != null ? '${time!.format(timeContext)}' : 'No specific time';
    return 'RamadanActivity{id: $id, title: $title, type: $type, time: $timeStr, date: $date, completed: $completed}';
  }

  // Helper context for TimeOfDay.format() method
  static BuildContext get timeContext {
    // This is a workaround for accessing TimeOfDay.format without a context
    // In a real app, use actual BuildContext from UI
    return _MockBuildContext();
  }
}

// A mock BuildContext for TimeOfDay.format()
class _MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}