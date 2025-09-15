class Todo {
  final int? id; // Primary key (auto-increment in SQLite)
  final String task; // Task description
  final bool isDone; // Completed or not
  final DateTime createdOn; // When created
  final DateTime updatedOn; // Last updated

  Todo({
    this.id,
    required this.task,
    this.isDone = false,
    required this.createdOn,
    required this.updatedOn,
  });

  /// Convert Todo to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'isDone': isDone ? 1 : 0,
      'createdOn': createdOn.toIso8601String(),
      'updatedOn': updatedOn.toIso8601String(),
    };
  }

  /// Convert Map back to Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int?,
      task: map['task'] as String,
      isDone: map['isDone'] == 1,
      createdOn: DateTime.parse(map['createdOn']),
      updatedOn: DateTime.parse(map['updatedOn']),
    );
  }
}
