import 'dart:math';

class Activity {
  final int id;
  final String title;
  final String type;
  final String time;
  final String? description;
  final bool completed;
  
  const Activity({
    required this.id,
    required this.title,
    required this.type,
    required this.time,
    this.description,
    this.completed = false,
  });
  
  Activity copyWith({
    int? id,
    String? title,
    String? type,
    String? time,
    String? description,
    bool? completed,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      time: time ?? this.time,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
  
  /// Create an activity with a random ID (for local use)
  factory Activity.create({
    required String title,
    required String type,
    required String time,
    String? description,
    bool completed = false,
  }) {
    return Activity(
      id: Random().nextInt(10000),
      title: title,
      type: type,
      time: time,
      description: description,
      completed: completed,
    );
  }
  
  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'time': time,
      'description': description,
      'completed': completed,
    };
  }
  
  /// Create from JSON response
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      time: json['time'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool? ?? false,
    );
  }
  
  @override
  String toString() {
    return 'Activity{id: $id, title: $title, type: $type, time: $time, completed: $completed}';
  }
}