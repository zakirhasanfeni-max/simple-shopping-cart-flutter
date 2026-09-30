import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: Checkbox(
          value: task.isCompleted,
          activeColor: Colors.green,
          onChanged: (_) {
            context.read<TaskProvider>().toggleTask(
              task.id,
            );
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted
                ? Colors.grey
                : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(task.description),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onPressed: () {
            context.read<TaskProvider>().deleteTask(
              task.id,
            );
          },
        ),
      ),
    );
  }
}