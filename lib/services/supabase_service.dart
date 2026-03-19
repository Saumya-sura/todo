import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Task> tasks = [];

  SupabaseService() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', supabase.auth.currentUser?.id)
        .execute();
    tasks = (response.data as List)
        .map((json) => Task.fromJson(json))
        .toList();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    await supabase.from('tasks').insert({
      'title': title,
      'completed': false,
      'user_id': supabase.auth.currentUser?.id,
    }).execute();
    fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id).execute();
    fetchTasks();
  }

  Future<void> toggleTask(String id) async {
    final task = tasks.firstWhere((t) => t.id == id);
    await supabase
        .from('tasks')
        .update({'completed': !task.completed})
        .eq('id', id)
        .execute();
    fetchTasks();
  }
}
