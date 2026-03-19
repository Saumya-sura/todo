import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback? onToggle;

  const TaskTile({
    required this.task,
    required this.onDelete,
    this.onToggle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF455A64) : Color(0xFFB0BEC5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: IconButton(
                key: ValueKey(task.completed),
                icon: Icon(
                  task.completed ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.yellow,
                ),
                onPressed: onToggle,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
