import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_by_bloc/data/model/todo_model.dart';

class TodoModelConstants {
  static const String tableName = "todo";

  static const String id = "_id";
  static const String title = "title";
  static const String color = "color";
}

class LocalDatabase {
  static final databaseInstance = LocalDatabase._();

  LocalDatabase._();

  factory LocalDatabase() {
    return databaseInstance;
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _init("todo.db");
      return _database!;
    }
  }

  Future<Database> _init(String databaseName) async {
    String internalPath = await getDatabasesPath();
    String path = join(internalPath, databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType2 = 'TEXT';

    await db.execute('''CREATE TABLE ${TodoModelConstants.tableName} (
      ${TodoModelConstants.id} $idType,
      ${TodoModelConstants.color} $textType2,
      ${TodoModelConstants.title} $textType2
    )''');
  }


  static Future<TodoModel> insertTodo(TodoModel todoModel) async {
    final db = await databaseInstance.database;
    int savedTaskID =
        await db.insert(TodoModelConstants.tableName, todoModel.toJson());
    todoModel = todoModel.copyWith(id: savedTaskID);
    return todoModel;
  }





  static Future<List<TodoModel>> searchNotes(String query) async {
    final db = await databaseInstance.database;

    var json = await db.query(TodoModelConstants.tableName,
        where: "${TodoModelConstants.title} LIKE ?", whereArgs: ["$query%"]);

    return json.map((e) => TodoModel.fromJson(e)).toList();
  }




  static Future<List<TodoModel>> getAllItems() async {
    final db = await databaseInstance.database;

    List<Map<String, dynamic>> json =
        await db.query(TodoModelConstants.tableName);
    return json.map((e) => TodoModel.fromJson(e)).toList();
  }

  static Future<int> deleteItem(int id) async {
    final db = await databaseInstance.database;
    int deletedId = await db.delete(TodoModelConstants.tableName,
        where: "${TodoModelConstants.id} = ?", whereArgs: [id]);
    return deletedId;
  }

  static Future<int> updateTodo(TodoModel todoModel,int id) async {
    final db = await databaseInstance.database;
   int a= await db.update(
      TodoModelConstants.tableName,
      todoModel.toJson(),
      where: '${TodoModelConstants.id} = ?',
      whereArgs: [id],
    );
    return a;
  }
}
