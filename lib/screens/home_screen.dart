import 'package:flutter/material.dart';
import 'package:ramadan_planner/models/activity.dart';
import 'package:ramadan_planner/models/prayer_time.dart';
import 'package:ramadan_planner/utils/constants.dart';
import 'package:ramadan_planner/widgets/prayer_time_card.dart';
import 'package:ramadan_planner/widgets/activity_card.dart';
import 'package:ramadan_planner/widgets/islamic_pattern.dart';
import 'package:ramadan_planner/widgets/ramadan_progress_indicator.dart';
import 'package:ramadan_planner/widgets/dua_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current Ramadan day (simulate for demo)
  int _currentRamadanDay = 12;
  int? _selectedDay;
  
  // Prayer times data using proper model
  final List<PrayerTime> _prayerTimes = [
    PrayerTime(name: 'Fajr', time: '04:30'),
    PrayerTime(name: 'Sunrise', time: '05:45'),
    PrayerTime(name: 'Dhuhr', time: '12:00'),
    PrayerTime(name: 'Asr', time: '15:15'),
    PrayerTime(name: 'Maghrib', time: '18:00'),
    PrayerTime(name: 'Isha', time: '19:30'),
  ];

  // Activities data using proper model
  final List<Activity> _activities = [
    Activity(
      id: 1,
      title: 'Read Quran',
      type: 'spiritual',
      time: '05:30',
      description: 'Read 5 pages of Quran after Fajr prayer',
    ),
    Activity(
      id: 2,
      title: 'Iftar Preparation',
      type: 'food',
      time: '17:00',
      description: 'Prepare dates, soup and main dish for Iftar',
    ),
    Activity(
      id: 3,
      title: 'Taraweeh Prayer',
      type: 'prayer',
      time: '20:00',
      description: 'Attend Taraweeh at the local mosque',
    ),
  ];
  
  // Dua data for Ramadan
  final Map<String, dynamic> _dua = {
    'arabicText': 'اللَّهُمَّ إِنِّي لَكَ صُمْتُ، وَبِكَ آمَنْتُ، وَعَلَيْكَ تَوَكَّلْتُ، وَعَلَى رِزْقِكَ أَفْطَرْتُ',
    'translation': 'O Allah, I fasted for You, I believed in You, I relied on You, and with Your provision I break my fast.',
    'transliteration': 'Allahumma inni laka sumtu, wa bika aamantu, wa alayka tawakkaltu, wa ala rizqika aftartu.',
    'reference': 'Abu Dawud',
    'isFavorite': false,
  };

  void _togglePrayerCompletion(int index) {
    setState(() {
      final updatedPrayer = _prayerTimes[index].copyWith(
        completed: !_prayerTimes[index].completed,
      );
      _prayerTimes[index] = updatedPrayer;
    });
  }

  void _toggleActivityCompletion(int index) {
    setState(() {
      _activities[index] = _activities[index].copyWith(
        completed: !_activities[index].completed,
      );
    });
  }
  
  void _toggleDuaFavorite() {
    setState(() {
      _dua['isFavorite'] = !_dua['isFavorite'];
    });
  }
  
  void _onDaySelected(int day) {
    setState(() {
      _selectedDay = day;
    });
    // In a full implementation, this would load data for the selected day
  }

  void _addActivity() {
    // Controller for input fields
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'spiritual'; // Default type
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Activity'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Activity Type',
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.activityTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type[0].toUpperCase() + type.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (HH:MM)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (titleController.text.isEmpty || timeController.text.isEmpty) {
                // Show error toast or feedback
                return;
              }
              
              // Add new activity to the list
              setState(() {
                _activities.add(
                  Activity.create(
                    title: titleController.text,
                    type: selectedType,
                    time: timeController.text,
                    description: descriptionController.text,
                  ),
                );
              });
              
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = "${today.day}/${today.month}/${today.year}";
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Islamic Pattern
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppConstants.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                children: [
                  const IslamicPattern(
                    height: 120,
                    backgroundColor: AppConstants.primaryColor,
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppConstants.primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Settings screen navigation would go here
                },
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Location section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Today: $formattedDate',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.location_on,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Surabaya, Indonesia',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Ramadan Progress Indicator (one of our interactive widgets)
                  RamadanProgressIndicator(
                    currentDay: _currentRamadanDay,
                    totalDays: AppConstants.ramadanDays,
                    onDaySelected: _onDaySelected,
                    selectedDay: _selectedDay,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Dua Card (one of our interactive widgets)
                  DuaCard(
                    arabicText: _dua['arabicText'],
                    translation: _dua['translation'],
                    transliteration: _dua['transliteration'],
                    reference: _dua['reference'],
                    isFavorite: _dua['isFavorite'],
                    onFavoriteToggle: _toggleDuaFavorite,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Prayer times section
                  const Text(
                    'Prayer Times',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _prayerTimes.length,
                    itemBuilder: (ctx, index) => PrayerTimeCard(
                      prayerTime: _prayerTimes[index],
                      onToggleCompletion: () => _togglePrayerCompletion(index),
                      isNextPrayer: index == 1, // Just for demonstration
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Activities section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Activities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppConstants.primaryColor,
                        ),
                        onPressed: _addActivity,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _activities.length,
                    itemBuilder: (ctx, index) => ActivityCard(
                      activity: _activities[index],
                      onToggleCompletion: () => _toggleActivityCompletion(index),
                      onEdit: () {
                        // Edit activity functionality would go here
                      },
                      onDelete: () {
                        setState(() {
                          _activities.removeAt(index);
                        });
                      },
                    ),
                  ),
                  
                  // Extra padding at the bottom for better UX
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        backgroundColor: AppConstants.secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}