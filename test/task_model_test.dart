import 'package:flutter_test/flutter_test.dart';
import '../lib/dashboard/task_model.dart';

void main() {
  test('Task serialization', () {
    final task = Task(id: '1', title: 'Test', completed: false);
    final json = task.toJson();
    final taskFromJson = Task.fromJson(json);
    expect(taskFromJson.id, '1');
    expect(taskFromJson.title, 'Test');
    expect(taskFromJson.completed, false);
  });
}
