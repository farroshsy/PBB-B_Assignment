import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';

class RamadanCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const RamadanCalendar({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _RamadanCalendarState createState() => _RamadanCalendarState();
}

class _RamadanCalendarState extends State<RamadanCalendar> {
  late PageController _pageController;
  late DateTime _currentMonth;
  
  final DateTime _today = DateTime.now();
  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _pageController = PageController(
      initialPage: _currentMonth.month + (_currentMonth.year - DateTime.now().year) * 12 - DateTime.now().month,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Calendar header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppTheme.primaryColor),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppTheme.primaryColor),
                onPressed: _nextMonth,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays
                .map(
                  (day) => SizedBox(
                    width: 30,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: day == 'F'
                            ? AppTheme.primaryColor // Highlight Friday as special day in Islam
                            : AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          
          const SizedBox(height: 8),
          
          // Calendar grid
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentMonth = DateTime(
                    DateTime.now().year + (page + DateTime.now().month) ~/ 12,
                    (page + DateTime.now().month) % 12 + 1,
                  );
                });
              },
              itemBuilder: (context, index) {
                final month = DateTime.now().month + index;
                final year = DateTime.now().year + month ~/ 12;
                final displayMonth = month % 12 + 1;
                return _buildMonthCalendar(DateTime(year, displayMonth));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    
    // Monday = 1, Sunday = 7 (ISO format)
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Total number of days to display (including leading and trailing days)
    final totalDays = firstWeekday - 1 + lastDayOfMonth.day;
    final totalWeeks = (totalDays / 7).ceil();
    
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: totalWeeks * 7,
      itemBuilder: (context, index) {
        // Calculate the date for this index
        final displayIndex = index - (firstWeekday - 1);
        if (displayIndex < 0 || displayIndex >= lastDayOfMonth.day) {
          // Return empty cell for previous/next month days
          return const SizedBox.shrink();
        }
        
        final day = displayIndex + 1;
        final date = DateTime(month.year, month.month, day);
        final isSelected = _isSameDay(date, widget.selectedDate);
        final isToday = _isSameDay(date, _today);
        
        return GestureDetector(
          onTap: () => widget.onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : isToday
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppTheme.primaryColor, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? AppTheme.primaryColor
                          : AppTheme.textColor,
                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _previousMonth() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextMonth() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
