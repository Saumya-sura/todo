import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/auth/auth_service.dart';
import 'package:todoapp/main.dart';
import 'dart:ui';

import '../services/supabase_service.dart';
import 'task_tile.dart';
import 'task_model.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  bool _isAnimating = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<double> _blurAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _opacityAnim = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _blurAnim = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateThemeToggle(VoidCallback toggleTheme) async {
    setState(() => _isAnimating = true);
    await _controller.forward();
    toggleTheme();
    await Future.delayed(Duration(milliseconds: 200));
    await _controller.reverse();
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<SupabaseService>(context);
    final tasks = taskService.tasks;
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget mainContent = Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Color(0xFF1B5E20) : Color(0xFF2E7D32), // Dark green for both themes
        title: Text('All Tasks', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.yellow),
            tooltip: 'Toggle Theme',
            onPressed: () => _animateThemeToggle(themeProvider.toggleTheme),
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
        color: isDark ? Color(0xFF37474F) : Colors.white,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: ValueKey(task.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => taskService.deleteTask(task.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                child: TaskTile(
                  task: task,
                  onDelete: () => taskService.deleteTask(task.id),
                  onToggle: () => taskService.toggleTask(task.id),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF388E3C) : Color(0xFF43A047), // Appealing green
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: Offset(0, -4),
              )
            ],
          ),
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: isDark ? Color(0xFF388E3C) : Color(0xFF43A047), width: 2),
                ),
                elevation: 2,
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
      ),
    );

    return Stack(
      children: [
        mainContent,
        if (_isAnimating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnim.value,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: _blurAnim.value, sigmaY: _blurAnim.value),
                  child: Container(
                    color: Colors.black.withOpacity(0.12),
                  ),
                ),
              );
            },
          ),
      ],
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
