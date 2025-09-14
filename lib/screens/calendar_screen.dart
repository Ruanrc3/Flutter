import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'task_list_screen.dart';

class CalendarScreen extends StatefulWidget {
  final String userName;
  const CalendarScreen({required this.userName, super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem Vindo, ${widget.userName}")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focused,
            selectedDayPredicate: (d) => isSameDay(d, _selected),
            onDaySelected: (selected, focused) {
              setState(() {
                _selected = selected;
                _focused = focused;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskListScreen(date: _selected)),
              );
            },
            child: Text("Ver tarefas - ${DateFormat('dd/MM/yyyy').format(_selected)}"),
          )
        ],
      ),
    );
  }
}
