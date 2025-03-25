class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }
  
  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  // Name validator
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }
  
  // Activity title validator
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    
    return null;
  }
  
  // Activity description validator
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    
    return null;
  }
  
  // Activity type validator
  static String? validateActivityType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an activity type';
    }
    
    return null;
  }
  
  // Date validator
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    
    return null;
  }
  
  // Time validator
  static String? validateTime(TimeOfDay? value) {
    if (value == null) {
      return 'Time is required';
    }
    
    return null;
  }
}
