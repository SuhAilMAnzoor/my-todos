import 'package:my_todos_application/model/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT NOT NULL,
        isDone INTEGER NOT NULL,
        createdOn TEXT NOT NULL,
        updatedOn TEXT NOT NULL
      )
    ''');
  }

  // Add a Todo
  Future<int> addTodo(Todo todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }

  // Get Todos (all or filtered by isDone)
  Future<List<Todo>> getTodos({bool? isDone}) async {
    final db = await instance.database;
    final maps = await db.query(
      'todos',
      where: isDone != null ? 'isDone = ?' : null,
      whereArgs: isDone != null ? [isDone ? 1 : 0] : null,
      orderBy: 'updatedOn DESC',
    );

    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  // Update Todo
  Future<int> updateTodo(Todo todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Delete Todo
  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  // Close DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
