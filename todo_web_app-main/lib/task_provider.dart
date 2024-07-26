// task_provider.dart

import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isDarkMode = false;

  List<Task> get tasks => _tasks;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) => isSameDay(task.date, date)).toList();
  }

  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  int get totalTasks => _tasks.length;

  int get completedTasksCount =>
      _tasks.where((task) => task.isCompleted).length;

  int get pendingTasksCount => _tasks.where((task) => !task.isCompleted).length;
}
