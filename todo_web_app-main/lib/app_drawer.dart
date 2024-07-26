import 'package:flutter/material.dart';
import 'task_list_view.dart';
import 'main.dart';
import 'calendar_view.dart'; // Import main.dart to access HomeScreen and CalendarView

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen()), // Navigate to HomeScreen defined in main.dart
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('My Tasks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskListView(DateTime.now())),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CalendarView()), // Navigate to CalendarView defined in main.dart
              );
            },
          ),
        ],
      ),
    );
  }
}
