import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_time.dart';
import '../providers/auth_provider.dart';
import '../providers/prayer_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/theme.dart';
import '../widgets/islamic_app_bar.dart';
import '../widgets/islamic_loader.dart';
import '../widgets/islamic_patterns.dart';
import '../widgets/prayer_time_card.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({Key? key}) : super(key: key);

  @override
  _PrayerScreenState createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  bool _isEditingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    
    // Initialize location controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
      _cityController.text = prayerProvider.city;
      _countryController.text = prayerProvider.country;
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await prayerProvider.getPrayerTimes(authProvider.currentUser!.id);
      await prayerProvider.getNextPrayer(authProvider.currentUser!.id);
    }
  }

  Future<void> _updateLocation() async {
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    
    prayerProvider.setLocation(_cityController.text, _countryController.text);
    setState(() {
      _isEditingLocation = false;
    });
    
    await _loadPrayerTimes();
  }

  Future<void> _selectDate(BuildContext context) async {
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    final DateTime currentDate = prayerProvider.selectedDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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

    if (pickedDate != null && pickedDate != currentDate) {
      prayerProvider.setSelectedDate(pickedDate);
      await _loadPrayerTimes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final prayerProvider = Provider.of<PrayerProvider>(context);

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view prayer times'),
        ),
      );
    }

    return Scaffold(
      appBar: IslamicAppBar(
        title: 'Prayer Times',
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
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
            onRefresh: _loadPrayerTimes,
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date and Location Card
                    _buildDateLocationCard(prayerProvider),
                    
                    const SizedBox(height: 24),
                    
                    // Next Prayer Card
                    _buildNextPrayerCard(prayerProvider),
                    
                    const SizedBox(height: 24),
                    
                    // Prayer Times Header
                    const Text(
                      'Prayer Schedule',
                      style: AppTheme.headingStyle,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Prayer Times List
                    prayerProvider.isLoading
                        ? Center(child: IslamicLoader(size: 40))
                        : prayerProvider.prayerTime == null
                            ? _buildErrorState()
                            : _buildPrayerTimesList(prayerProvider.prayerTime!),
                    
                    // Islamic Quote
                    const SizedBox(height: 32),
                    _buildIslamicQuote(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateLocationCard(PrayerProvider prayerProvider) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prayer Times for',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textColor.withOpacity(0.7),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isEditingLocation ? Icons.check : Icons.edit,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  if (_isEditingLocation) {
                    _updateLocation();
                  } else {
                    setState(() {
                      _isEditingLocation = true;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormatter.formatDate(prayerProvider.selectedDate),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          _isEditingLocation
              ? _buildLocationEditForm()
              : Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${prayerProvider.city}, ${prayerProvider.country}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildLocationEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _countryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Note: Use full country name for better accuracy',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.accentColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCard(PrayerProvider prayerProvider) {
    if (prayerProvider.nextPrayer == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: AppTheme.prayerCardDecoration.copyWith(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.05),
            AppTheme.secondaryColor.withOpacity(0.05),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Next Prayer',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prayerProvider.nextPrayer!['name'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  DateFormatter.formatTime(prayerProvider.nextPrayer!['time'] as TimeOfDay),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Center(
            child: Text(
              prayerProvider.nextPrayer!['isToday'] as bool
                  ? 'Today'
                  : 'Tomorrow',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesList(PrayerTime prayerTime) {
    return Column(
      children: [
        for (final prayerName in AppConstants.prayerNames)
          PrayerTimeCard(
            prayerName: prayerName,
            time: prayerTime.getPrayerByName(prayerName),
            isNextPrayer: Provider.of<PrayerProvider>(context).nextPrayer != null &&
                Provider.of<PrayerProvider>(context).nextPrayer!['name'] == prayerName &&
                Provider.of<PrayerProvider>(context).nextPrayer!['isToday'] == true,
          ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load prayer times',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and location settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPrayerTimes,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
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

  Widget _buildIslamicQuote() {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.format_quote,
            color: AppTheme.secondaryColor,
            size: 32,
          ),
          const SizedBox(height: 12),
          const Text(
            'The five daily prayers erase the sins committed between them, so long as major sins are avoided.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '- Sahih Muslim',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
