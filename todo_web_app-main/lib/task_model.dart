class Task {
  final String title;
  final String description; // New field
  final DateTime date;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}
