class TaskModel {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}