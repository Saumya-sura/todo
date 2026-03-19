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
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: ListTile(
        title: Text(task.title),
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
                  color: task.completed ? Colors.green : null,
                ),
                onPressed: onToggle,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
