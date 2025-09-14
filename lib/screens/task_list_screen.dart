import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskListScreen extends StatelessWidget {
  final DateTime date;
  const TaskListScreen({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasksForDate(date);

    return Scaffold(
      appBar: AppBar(title: Text("Dia ${DateFormat('dd/MM/yyyy').format(date)}")),
      body: Column(
        children: [
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text("Nenhuma tarefa"))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      final t = tasks[i];
                      return ListTile(
                        title: Text(
                          t.title,
                          style: TextStyle(
                            decoration: t.done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: t.done,
                          onChanged: (_) => provider.toggleDone(t),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => provider.removeTask(t),
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddDialog(context, provider),
            icon: const Icon(Icons.add),
            label: const Text("Adicionar tarefa"),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, TaskProvider provider) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nova tarefa"),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                final task = Task(
                  id: UniqueKey().toString(),
                  title: ctrl.text,
                  date: date,
                );
                provider.addTask(task);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }
}
