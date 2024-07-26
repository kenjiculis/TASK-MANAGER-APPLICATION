import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task_list_view.dart';
import 'app_drawer.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<TaskProvider>(context).isDarkMode
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).toggleTheme();
            },
          ),
          Switch(
            value: Provider.of<TaskProvider>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<TaskProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          TableCalendar(
            locale: 'en_US',
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = selectedDay;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskListView(selectedDay)),
              );
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) => buildCalendarDay(date),
              selectedBuilder: (context, date, _) =>
                  buildCalendarDay(date, isSelected: true),
              todayBuilder: (context, date, _) =>
                  buildCalendarDay(date, isToday: true),
              markerBuilder: (context, date, events) {
                final tasks =
                    Provider.of<TaskProvider>(context).getTasksForDate(date);
                if (tasks.isNotEmpty) {
                  return Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendarDay(DateTime date,
      {bool isSelected = false, bool isToday = false}) {
    final tasks = Provider.of<TaskProvider>(context).getTasksForDate(date);
    final isDarkMode = Provider.of<TaskProvider>(context).isDarkMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Colors.blue
              : (isToday ? Colors.grey : Colors.transparent),
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: isSelected || isToday
                  ? Colors.white
                  : isDarkMode
                      ? Colors.white
                      : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
