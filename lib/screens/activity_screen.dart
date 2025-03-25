import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/activity_provider.dart';
import '../screens/add_activity_screen.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/theme.dart';
import '../widgets/activity_card.dart';
import '../widgets/islamic_app_bar.dart';
import '../widgets/islamic_loader.dart';
import '../widgets/islamic_patterns.dart';
import '../widgets/ramadan_calendar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String? _selectedActivityType;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await activityProvider.getActivities(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final activityProvider = Provider.of<ActivityProvider>(context);
    
    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your activities'),
        ),
      );
    }

    return Scaffold(
      appBar: IslamicAppBar(
        title: 'Activities',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
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
          RefreshIndicator(
            onRefresh: _loadActivities,
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar widget
                    RamadanCalendar(
                      selectedDate: activityProvider.selectedDate,
                      onDateSelected: (date) {
                        activityProvider.setSelectedDate(date, authProvider.currentUser!.id);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Filter by activity type
                    _buildActivityTypeFilter(activityProvider, authProvider),
                    
                    const SizedBox(height: 24),
                    
                    // Activities header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getActivitiesTitle(activityProvider),
                          style: AppTheme.headingStyle,
                        ),
                        if (_selectedActivityType != null || activityProvider.selectedDate != DateTime.now())
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedActivityType = null;
                              });
                              activityProvider.clearFilters(authProvider.currentUser!.id);
                            },
                            child: const Text(
                              'Clear Filters',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Activities list
                    activityProvider.isLoading
                        ? Center(child: IslamicLoader(size: 40))
                        : activityProvider.filteredActivities.isEmpty
                            ? _buildEmptyState()
                            : Column(
                                children: activityProvider.filteredActivities
                                    .map((activity) => Padding(
                                          padding: const EdgeInsets.only(bottom: 16.0),
                                          child: ActivityCard(
                                            activity: activity,
                                            showDate: true,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => AddActivityScreen(
                                                    activity: activity,
                                                  ),
                                                ),
                                              ).then((_) => _loadActivities());
                                            },
                                            onToggleCompletion: () {
                                              activityProvider.toggleActivityCompletion(
                                                activity.id!,
                                                authProvider.currentUser!.id,
                                              );
                                            },
                                          ),
                                        ))
                                    .toList(),
                              ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddActivityScreen()),
          ).then((_) => _loadActivities());
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getActivitiesTitle(ActivityProvider activityProvider) {
    if (_selectedActivityType != null) {
      return '$_selectedActivityType Activities';
    } else if (DateFormatter.isToday(activityProvider.selectedDate)) {
      return 'Today\'s Activities';
    } else {
      return 'Activities for ${DateFormatter.formatShortDate(activityProvider.selectedDate)}';
    }
  }

  Widget _buildActivityTypeFilter(ActivityProvider activityProvider, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by Type',
          style: AppTheme.subheadingStyle,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final type in AppConstants.activityTypes)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(type),
                    selected: _selectedActivityType == type,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedActivityType = type;
                          activityProvider.setSelectedType(type, authProvider.currentUser!.id);
                        } else {
                          _selectedActivityType = null;
                          activityProvider.clearFilters(authProvider.currentUser!.id);
                        }
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _selectedActivityType == type
                          ? AppTheme.primaryColor
                          : AppTheme.textColor,
                      fontWeight: _selectedActivityType == type
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 70,
              color: AppTheme.accentColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No activities found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedActivityType != null
                  ? 'Try selecting a different activity type'
                  : 'Try selecting a different date or add a new activity',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddActivityScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Activity'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Activities',
                    style: AppTheme.headingStyle,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'By Activity Type',
                    style: AppTheme.subheadingStyle,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.activityTypes
                        .map((type) => ChoiceChip(
                              label: Text(type),
                              selected: _selectedActivityType == type,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedActivityType = type;
                                  } else {
                                    _selectedActivityType = null;
                                  }
                                });
                                
                                if (selected) {
                                  activityProvider.setSelectedType(
                                    type, 
                                    authProvider.currentUser!.id
                                  );
                                } else {
                                  activityProvider.clearFilters(
                                    authProvider.currentUser!.id
                                  );
                                }

                                // Update parent state too
                                this.setState(() {});
                              },
                              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _selectedActivityType == type
                                    ? AppTheme.primaryColor
                                    : AppTheme.textColor,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedActivityType = null;
                          });
                          activityProvider.clearFilters(authProvider.currentUser!.id);
                          this.setState(() {}); // Update parent state
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(color: AppTheme.accentColor),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
