import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/auth/auth_service.dart';

import '../services/supabase_service.dart';
import 'task_tile.dart';
import 'task_model.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<SupabaseService>(context);
    final tasks = taskService.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskTile(
            task: task,
            onDelete: () => taskService.deleteTask(task.id),
            onToggle: () => taskService.toggleTask(task.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddTaskSheet(),
          );
        },
        child: Icon(Icons.add),
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
