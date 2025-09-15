import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_todos_application/model/todo.dart';
import 'package:my_todos_application/services/database_services.dart';

class CompletedTodosScreen extends StatefulWidget {
  const CompletedTodosScreen({super.key});

  @override
  State<CompletedTodosScreen> createState() => _CompletedTodosScreenState();
}

class _CompletedTodosScreenState extends State<CompletedTodosScreen> {
  final DatabaseService _dbService = DatabaseService.instance;
  List<Todo> _completedTodos = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedTodos();
  }

  Future<void> _loadCompletedTodos() async {
    final todos = await _dbService.getTodos(isDone: true);
    setState(() {
      _completedTodos = todos;
    });
  }

  void _deleteTodo(int id) async {
    await _dbService.deleteTodo(id);
    _loadCompletedTodos();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Todo deleted")));
  }

  // ✅ Group todos into Today, Tomorrow, Yesterday, Others
  Map<String, List<Todo>> _groupTodos(List<Todo> todos) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, List<Todo>> grouped = {
      "Today": [],
      "Tomorrow": [],
      "Yesterday": [],
      "Other Days": [],
    };

    for (var todo in todos) {
      final date = DateTime(
        todo.updatedOn.year,
        todo.updatedOn.month,
        todo.updatedOn.day,
      );

      if (date == DateTime(today.year, today.month, today.day)) {
        grouped["Today"]!.add(todo);
      } else if (date ==
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day)) {
        grouped["Tomorrow"]!.add(todo);
      } else if (date ==
          DateTime(yesterday.year, yesterday.month, yesterday.day)) {
        grouped["Yesterday"]!.add(todo);
      } else {
        grouped["Other Days"]!.add(todo);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTodos = _groupTodos(_completedTodos);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          "Completed Todos",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _completedTodos.isEmpty
          ? const Center(
              child: Text(
                "No completed todos yet!",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            )
          : ListView(
              children: groupedTodos.entries
                  .where(
                    (entry) => entry.value.isNotEmpty,
                  ) // hide empty categories
                  .map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Category Header
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // ✅ Todos in that category
                        ...entry.value.map((todo) {
                          return Dismissible(
                            key: ValueKey(todo.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) => _deleteTodo(todo.id!),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 28,
                                ),
                                title: Text(
                                  todo.task,
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  "Completed: ${DateFormat("dd-MM-yyyy h:mm a").format(todo.updatedOn)}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  })
                  .toList(),
            ),
    );
  }
}
