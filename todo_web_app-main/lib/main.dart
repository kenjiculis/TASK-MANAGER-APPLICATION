import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'calendar_view.dart';
import 'task_list_view.dart';
import 'dashboard_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return MaterialApp(
            title: 'Flutter ToDo Web App',
            theme: taskProvider.isDarkMode
                ? ThemeData.dark().copyWith(
                    textTheme: Theme.of(context).textTheme.apply(
                          fontFamily: 'Poppins',
                          bodyColor: Colors.white,
                        ),
                  )
                : ThemeData.light().copyWith(
                    textTheme: Theme.of(context).textTheme.apply(
                          fontFamily: 'Poppins',
                        ),
                  ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo'),
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
        ],
      ),
      drawer: AppDrawer(),
      body: DashboardView(),
    );
  }
}

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
                MaterialPageRoute(builder: (context) => HomeScreen()),
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
                MaterialPageRoute(builder: (context) => CalendarView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
