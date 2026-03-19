import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todoapp/services/supabase_service.dart';
import 'task_model.dart';
import 'package:provider/provider.dart';

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
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF455A64) : Color(0xFFB0BEC5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.yellow,
          child: Icon(Icons.task, color: Colors.black),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
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
              icon: Icon(Icons.edit, color: Colors.white),
              tooltip: 'Edit Task',
              onPressed: () async {
                final controller = TextEditingController(text: task.title);
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Edit Task'),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(labelText: 'Task Title'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, controller.text),
                        child: Text('Save'),
                      ),
                    ],
                  ),
                );
                if (result != null && result.trim().isNotEmpty && result != task.title) {
                  context.read<SupabaseService>().editTask(task.id, result.trim());
                }
              },
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
