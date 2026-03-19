import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/auth/auth_service.dart';
import 'package:todoapp/main.dart';

import '../services/supabase_service.dart';
import 'task_tile.dart';
import 'task_model.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<SupabaseService>(context);
    final tasks = taskService.tasks;
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Color(0xFF263238) : Color(0xFF607D8B),
        title: Text('All Tasks', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.yellow),
            tooltip: 'Toggle Theme',
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        color: isDark ? Color(0xFF37474F) : Color(0xFF90A4AE),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              child: TaskTile(
                task: task,
                onDelete: () => taskService.deleteTask(task.id),
                onToggle: () => taskService.toggleTask(task.id),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: isDark ? Color(0xFF263238) : Color(0xFF607D8B),
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => AddTaskSheet(),
              );
            },
            child: Text('Add Task'),
          ),
        ),
      ),
    );
  }
}

class AddTaskSheet extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Provider.of<SupabaseService>(context, listen: false)
                  .addTask(controller.text);
              Navigator.pop(context);
            },
            child: Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
