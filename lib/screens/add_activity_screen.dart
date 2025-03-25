import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ramadan_activity.dart';
import '../providers/auth_provider.dart';
import '../providers/activity_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../widgets/islamic_app_bar.dart';
import '../widgets/islamic_button.dart';
import '../widgets/islamic_text_field.dart';
import '../widgets/islamic_patterns.dart';

class AddActivityScreen extends StatefulWidget {
  final RamadanActivity? activity;

  const AddActivityScreen({
    Key? key,
    this.activity,
  }) : super(key: key);

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  String _selectedActivityType = AppConstants.activityTypes[0];
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  bool _isCompleted = false;
  
  bool get _isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers and values from activity if editing
    if (_isEditing) {
      _titleController = TextEditingController(text: widget.activity!.title);
      _descriptionController = TextEditingController(text: widget.activity!.description);
      _selectedActivityType = widget.activity!.activityType;
      _selectedDate = widget.activity!.date;
      _selectedTime = widget.activity!.time;
      _isCompleted = widget.activity!.isCompleted;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    
    if (authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to save activities'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    bool success;
    if (_isEditing) {
      // Update existing activity
      final updatedActivity = widget.activity!.copyWith(
        title: title,
        description: description,
        activityType: _selectedActivityType,
        date: _selectedDate,
        time: _selectedTime,
        isCompleted: _isCompleted,
      );
      
      success = await activityProvider.updateActivity(updatedActivity);
    } else {
      // Create new activity
      final newActivity = RamadanActivity(
        userId: authProvider.currentUser!.id,
        title: title,
        description: description,
        activityType: _selectedActivityType,
        date: _selectedDate,
        time: _selectedTime,
        isCompleted: _isCompleted,
      );
      
      success = await activityProvider.addActivity(newActivity);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing 
              ? AppConstants.activityUpdatedMessage 
              : AppConstants.activityAddedMessage
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _deleteActivity() async {
    if (!_isEditing) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    
    final success = await activityProvider.deleteActivity(
      widget.activity!.id!,
      authProvider.currentUser!.id,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.activityDeletedMessage),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      appBar: IslamicAppBar(
        title: _isEditing ? 'Edit Activity' : 'Add Activity',
        actions: _isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteActivity,
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          // Islamic pattern background
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: IslamicPatterns.geometricPattern(),
            ),
          ),
          
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    IslamicTextField(
                      controller: _titleController,
                      label: 'Activity Title',
                      hint: 'Enter activity title',
                      prefixIcon: Icons.title_outlined,
                      validator: Validators.validateTitle,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Activity type dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Activity Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.accentColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedActivityType,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
                              items: AppConstants.activityTypes
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Row(
                                          children: [
                                            Icon(
                                              _getActivityTypeIcon(type),
                                              color: AppTheme.primaryColor,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(type),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedActivityType = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Date and time selectors
                    Row(
                      children: [
                        // Date picker
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.accentColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: AppTheme.primaryColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        DateFormatter.formatShortDate(_selectedDate),
                                        style: const TextStyle(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Time picker
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time (Optional)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectTime(context),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.accentColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: AppTheme.primaryColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        _selectedTime == null
                                            ? 'Not set'
                                            : DateFormatter.formatTime(_selectedTime!),
                                        style: TextStyle(
                                          color: _selectedTime == null
                                              ? AppTheme.textColor.withOpacity(0.5)
                                              : AppTheme.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description field
                    IslamicTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Enter activity description',
                      prefixIcon: Icons.description_outlined,
                      maxLines: 5,
                      validator: Validators.validateDescription,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Completed checkbox (only for editing)
                    if (_isEditing)
                      CheckboxListTile(
                        title: const Text('Mark as completed'),
                        value: _isCompleted,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _isCompleted = value;
                            });
                          }
                        },
                        activeColor: AppTheme.primaryColor,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Error message
                    if (activityProvider.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                activityProvider.errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: IslamicButton(
                        text: _isEditing ? 'Update Activity' : 'Add Activity',
                        isLoading: activityProvider.isLoading,
                        onPressed: _saveActivity,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityTypeIcon(String activityType) {
    switch (activityType) {
      case 'Prayer':
        return Icons.mosque;
      case 'Quran Reading':
        return Icons.menu_book;
      case 'Iftar':
        return Icons.dinner_dining;
      case 'Suhoor':
        return Icons.breakfast_dining;
      case 'Taraweeh':
        return Icons.nightlight;
      case 'Charity':
        return Icons.volunteer_activism;
      case 'Dua':
        return Icons.favorite;
      default:
        return Icons.event_note;
    }
  }
}
