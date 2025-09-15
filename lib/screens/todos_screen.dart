import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_todos_application/model/todo.dart';
import 'package:my_todos_application/screens/completed_todos_screen.dart';
import 'package:my_todos_application/services/database_services.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textController = TextEditingController();
  final DatabaseService _dbService = DatabaseService.instance;

  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    final todos = await _dbService.getTodos(isDone: false);
    setState(() {
      _todos = todos;
    });
  }

  void _addTodo() async {
    if (_textController.text.trim().isEmpty) return;
    final todo = Todo(
      task: _textController.text.trim(),
      isDone: false,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
    await _dbService.addTodo(todo);
    _textController.clear();
    _loadTodos();
  }

  void _toggleTodoStatus(Todo todo) async {
    final updated = Todo(
      id: todo.id,
      task: todo.task,
      isDone: !todo.isDone,
      createdOn: todo.createdOn,
      updatedOn: DateTime.now(),
    );
    await _dbService.updateTodo(updated);
    _loadTodos();
  }

  void _editTodoDialog(Todo todo) {
    final controller = TextEditingController(text: todo.task);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit todo"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Update your task",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final updated = Todo(
                id: todo.id,
                task: controller.text.trim(),
                isDone: todo.isDone,
                createdOn: todo.createdOn,
                updatedOn: DateTime.now(),
              );
              await _dbService.updateTodo(updated);
              Navigator.pop(context);
              _loadTodos();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteTodo(int id) async {
    await _dbService.deleteTodo(id);
    _loadTodos();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Todo deleted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "My Todos",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            // fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompletedTodosScreen()),
              );
            },
          ),
        ],
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                "Add your todos!",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        todo.task,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        DateFormat("dd-MM-yyyy h:mm a").format(todo.updatedOn),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              todo.isDone;
                              _toggleTodoStatus(todo);
                            },
                            icon: Icon(Icons.check_circle_outline),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTodoDialog(todo),
                          ),
                        ],
                      ),
                      onLongPress: () =>
                          _deleteTodo(todo.id!), // delete on long press
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  void _showAddDialog() {
    _textController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        title: const Text("Add a Todo"),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: "Enter task"),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF3D84A7),
              foregroundColor: Colors.white, // text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              _addTodo();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
