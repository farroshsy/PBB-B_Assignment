class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String location;
  final bool isDarkModeEnabled;
  final bool isNotificationsEnabled;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.location,
    this.isDarkModeEnabled = false,
    this.isNotificationsEnabled = true,
    required this.createdAt,
    this.lastLoginAt,
  });

  // Create a copy of this user with some updated fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? location,
    bool? isDarkModeEnabled,
    bool? isNotificationsEnabled,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // Convert the user to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'location': location,
      'is_dark_mode_enabled': isDarkModeEnabled,
      'is_notifications_enabled': isNotificationsEnabled,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  // Create a user from a map (e.g., from database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      location: map['location'],
      isDarkModeEnabled: map['is_dark_mode_enabled'] as bool? ?? false,
      isNotificationsEnabled: map['is_notifications_enabled'] as bool? ?? true,
      createdAt: map['created_at'] is DateTime
          ? map['created_at']
          : DateTime.parse(map['created_at']),
      lastLoginAt: map['last_login_at'] == null
          ? null
          : map['last_login_at'] is DateTime
              ? map['last_login_at']
              : DateTime.parse(map['last_login_at']),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, location: $location)';
  }
}