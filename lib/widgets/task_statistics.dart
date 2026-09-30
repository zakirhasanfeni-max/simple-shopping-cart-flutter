import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskStatistics extends StatelessWidget {
  const TaskStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            _statCard(
              'Total',
              provider.totalTasks,
              Colors.blue,
              Icons.checklist,
            ),
            const SizedBox(width: 10),
            _statCard(
              'Completed',
              provider.completedTasks,
              Colors.green,
              Icons.task_alt,
            ),
            const SizedBox(width: 10),
            _statCard(
              'Pending',
              provider.pendingTasks,
              Colors.orange,
              Icons.pending_actions,
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
      String title,
      int count,
      Color color,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}