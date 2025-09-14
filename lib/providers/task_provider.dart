import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final Map<String, List<Task>> _tasksByDate = {};

  String _keyFromDate(DateTime d) =>
      '${d.year}-${d.month}-${d.day}';

  List<Task> tasksForDate(DateTime date) {
    final key = _keyFromDate(date);
    final list = _tasksByDate[key] ?? [];

    // Ordenação: pendentes primeiro, depois concluídas, alfabético
    list.sort((a, b) {
      if (a.done == b.done) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
      return a.done ? 1 : -1;
    });

    return List.unmodifiable(list);
  }

  void addTask(Task task) {
    final key = _keyFromDate(task.date);
    _tasksByDate.putIfAbsent(key, () => []);
    _tasksByDate[key]!.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    final key = _keyFromDate(task.date);
    _tasksByDate[key]?.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  void toggleDone(Task task) {
    task.done = !task.done;
    notifyListeners();
  }
}
