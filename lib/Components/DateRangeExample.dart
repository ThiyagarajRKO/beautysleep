import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Utilis/theme.dart';

class DateRangeExample extends StatefulWidget {
  @override
  _DateRangeExampleState createState() => _DateRangeExampleState();

  final RxString? selectedDate;
  final bool? isCurrentData;

  const DateRangeExample({super.key, 
    @required this.selectedDate,
    this.isCurrentData = false,
  });

}

class _DateRangeExampleState extends State<DateRangeExample> {
  DateTimeRange? _selectedDateRange;
  bool thismonth = false;
  bool lastmonth = false;
  bool lastyear = false;

  DateTime selectedDay = DateTime.now();
  final DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  bool _isDateEnabled(DateTime day) {
    // Enable only future dates or the current date
    return day.isAfter(_currentDate) || _isSameDay(day, _currentDate);
  }

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20, width: 20),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text("Select Date",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.clear))
              ],
            ),
          ),
          const Divider(),
          TableCalendar(
              firstDay: DateTime.utc(_currentDate.year - 1),
              lastDay: widget.isCurrentData!
                  ? DateTime.now()
                  : DateTime.utc(_currentDate.year + 2),
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.black),
                selectedDecoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  shape: BoxShape.rectangle,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              rangeStartDay: DateTime.now(),
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },
              availableGestures: AvailableGestures.none,
              // Disable selecting previous dates
              onDaySelected: (DateTime selectedDate, DateTime focusedDate) {
                setState(() {
                  selectedDay = selectedDate;
                  widget.selectedDate?.value =
                      formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
                });
              },
              // locale: "en_US",
              rowHeight: 35,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color: Colors.black),
              ),
              focusedDay: selectedDay,
              daysOfWeekVisible: true,
              calendarBuilders:
                  CalendarBuilders(selectedBuilder: (context, date, _) {
                return Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5)),
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              })),
        ],
      ),
    );
  }
}
