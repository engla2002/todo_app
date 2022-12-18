import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      // ignore: prefer_interpolation_to_compose_strings
      String path = await getDatabasesPath() + 'tasks_db';
      //String path = dir.path + 'tasks_db';
      _db =
          await openDatabase(path, version: _version, onCreate: (db, version) {
        print("creating a new one");
        return db.execute(
            "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, startTime STRING, "
            "endTime STRING, remind INTEGER, repeat STRING, color INTEGER, "
            "isCompleted INTEGER)");
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    await initDb();
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    await initDb();
    print("quey function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    await initDb();
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    await initDb();
    _db!.rawUpdate('''
UPDATE $_tableName
SET isCompleted = ?
WHERE id = ?
''', [1, id]);
  }
}
