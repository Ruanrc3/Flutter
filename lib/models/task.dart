class Task {
  String id;
  String title;
  DateTime date;
  bool done;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.done = false,
  });
}
