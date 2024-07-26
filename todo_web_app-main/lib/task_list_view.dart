import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task_model.dart';
import 'app_drawer.dart';
import 'calendar_view.dart';

class TaskListView extends StatelessWidget {
  TaskListView(DateTime selectedDay);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Tasks'),
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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            TaskListViewTab(isCompleted: false),
            TaskListViewTab(isCompleted: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddTaskDialog();
              },
            );
          },
        ),
      ),
    );
  }
}

class TaskListViewTab extends StatelessWidget {
  final bool isCompleted;

  TaskListViewTab({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = isCompleted
            ? taskProvider.completedTasks
            : taskProvider.pendingTasks;

        Map<DateTime, List<Task>> groupedTasks = groupTasksByDate(tasks);

        return ListView.builder(
          itemCount: groupedTasks.length,
          itemBuilder: (context, index) {
            DateTime date = groupedTasks.keys.elementAt(index);
            List<Task> tasksForDate = groupedTasks[date] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  // color: Colors.grey.shade300,
                  child: Text(
                    formatDate(date),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tasksForDate.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey),
                  itemBuilder: (context, index) {
                    final task = tasksForDate[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: task.isCompleted
                              ? [Colors.green.shade300, Colors.greenAccent]
                              : [
                                  Colors.blue.shade300,
                                  const Color.fromARGB(255, 62, 132, 237)
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(task.title,
                            style: TextStyle(color: Colors.white)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.description,
                                style: TextStyle(color: Colors.white)),
                            Text(
                              // Format date and time together
                              '${Provider.of<TaskProvider>(context, listen: false).formatDate(task.date)} ${_formatTime(task.date)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            taskProvider.toggleTaskStatus(task);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper function to group tasks by date
  Map<DateTime, List<Task>> groupTasksByDate(List<Task> tasks) {
    Map<DateTime, List<Task>> groupedTasks = {};

    for (Task task in tasks) {
      DateTime date = DateTime(task.date.year, task.date.month, task.date.day);

      if (groupedTasks.containsKey(date)) {
        groupedTasks[date]!.add(task);
      } else {
        groupedTasks[date] = [task];
      }
    }

    return groupedTasks;
  }

  // Helper function to format date as 'Month Day, Year'
  String formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  // Helper function to format time
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}';
  }

  // Helper function to get month name from month number
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 10),
          Container(
            // Wrap TextField in a Container for description
            height: 120, // Adjust the height as needed
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: null, // Allows for multiline input
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                  "Date: ${Provider.of<TaskProvider>(context, listen: false).formatDate(_selectedDate)}"),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              Text("Time: ${_selectedTime.format(context)}"),
              IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final task = Task(
              title: _titleController.text,
              description: _descriptionController.text, // Pass description
              date: DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              ),
            );
            Provider.of<TaskProvider>(context, listen: false).addTask(task);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
