import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

// 🔥 Removido Firebase para rodar no Windows

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()), // seu provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gerenciador de Tarefas',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

/// FUNÇÃO PARA NAVEGAÇÃO ANIMADA
Route createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.1, 0.2);
      const end = Offset.zero;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation.drive(fadeTween), child: child),
      );
    },
  );
}

/// LOGIN
class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.task_alt, size: 60, color: Colors.purple),
                  const SizedBox(height: 15),
                  Text("Bem-vindo!",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        createRoute(CalendarScreen()),
                      );
                    },
                    child: const Text("Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        createRoute(RegisterScreen()),
                      );
                    },
                    child: const Text("Não tem conta? Cadastre-se"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CADASTRO
class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cadastrar"),
            )
          ],
        ),
      ),
    );
  }
}

/// CALENDÁRIO
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> tasks = {};
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendário de Tarefas"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text("Selecione um dia"))
                : TaskList(
                    listKey: _listKey,
                    selectedDay: _selectedDay!,
                    tasks: tasks[_selectedDay] ?? [],
                    onAddTask: (task) {
                      setState(() {
                        tasks[_selectedDay!] = [
                          ...(tasks[_selectedDay] ?? []),
                          {"title": task, "done": false}
                        ];
                      });
                      _listKey.currentState?.insertItem(
                          (tasks[_selectedDay] ?? []).length - 1);
                    },
                    onToggleTask: (index) {
                      setState(() {
                        tasks[_selectedDay]![index]["done"] =
                            !tasks[_selectedDay]![index]["done"];
                      });
                    },
                    onRemoveTask: (index) {
                      final removedTask = tasks[_selectedDay]![index];
                      setState(() {
                        tasks[_selectedDay]!.removeAt(index);
                      });
                      _listKey.currentState?.removeItem(
                        index,
                        (context, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: ListTile(
                              title: Text(removedTask["title"]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// LISTA DE TAREFAS COM ANIMAÇÃO
class TaskList extends StatefulWidget {
  final DateTime selectedDay;
  final List<Map<String, dynamic>> tasks;
  final Function(String) onAddTask;
  final Function(int) onToggleTask;
  final Function(int) onRemoveTask;
  final GlobalKey<AnimatedListState> listKey;

  TaskList({
    required this.selectedDay,
    required this.tasks,
    required this.onAddTask,
    required this.onToggleTask,
    required this.onRemoveTask,
    required this.listKey,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _fabExpanded = false;

  @override
  Widget build(BuildContext context) {
    final sortedTasks = [...widget.tasks];
    sortedTasks.sort((a, b) {
      if (a["done"] == b["done"]) {
        return a["title"].toLowerCase().compareTo(b["title"].toLowerCase());
      }
      return a["done"] ? 1 : -1;
    });

    return Column(
      children: [
        Text(
          "Dia ${widget.selectedDay.day}/${widget.selectedDay.month}/${widget.selectedDay.year}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: AnimatedList(
            key: widget.listKey,
            initialItemCount: sortedTasks.length,
            itemBuilder: (context, index, animation) {
              final task = sortedTasks[index];
              return SizeTransition(
                sizeFactor: animation,
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Icon(
                      task["done"]
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task["done"] ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      task["title"],
                      style: TextStyle(
                        decoration: task["done"]
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onRemoveTask(index),
                    ),
                    onTap: () => widget.onToggleTask(index),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: _fabExpanded ? 1.2 : 1.0,
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() => _fabExpanded = !_fabExpanded);
              showDialog(
                context: context,
                builder: (context) {
                  final taskController = TextEditingController();
                  return AlertDialog(
                    title: const Text("Nova tarefa"),
                    content: TextField(
                      controller: taskController,
                      decoration:
                          const InputDecoration(hintText: "Digite a tarefa"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (taskController.text.isNotEmpty) {
                            widget.onAddTask(taskController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Adicionar"),
                      )
                    ],
                  );
                },
              );
            },
            label: const Text("Adicionar tarefa"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.purple,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
