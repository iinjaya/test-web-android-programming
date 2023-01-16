import 'package:sqflite/sqflite.dart' as sql;
import 'package:todo_app/core.dart';

abstract class SQLHelper implements SQLDatabase {
  final String dbPath = 'db_todoApp.db';

  Future<void> _createTable(sql.Database db) async {
    String query = "CREATE TABLE $table ($definition)";
    Get.consoleLog('creating table $table');
    await Future.delayed(const Duration(milliseconds: 2500), () async {
      await db.execute(query);
    });
    Get.consoleLog('table $table created');
  }

  Future<void> deleteDatabases() async => await sql.deleteDatabase(dbPath);

  Future<sql.Database> createDatabase() async {
    return sql.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async => await _createTable(db),
      singleInstance: true,
    );
  }

  Future<sql.Database> db() async => await createDatabase();

  Future<int> createItem({required Map<String, dynamic> values}) async {
    final connection = await db();
    final id = await connection.insert(
      table!,
      values,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    await connection.close();
    return id;
  }

  Future<int> updateItem({required Map<String, dynamic> values, required String id}) async {
    final connection = await db();
    final updateRow = await connection.update(
      table!,
      values,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
    await connection.close();
    return updateRow;
  }

  Future<int> deleteItem({required String id}) async {
    final connection = await db();
    final deletedRow = await connection.delete(
      table!,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
    await connection.close();
    return deletedRow;
  }

  Future<List<Map<String, dynamic>>> all({
    List<String>? columns,
    String? orderBy,
  }) async {
    final connection = await db();
    final rows = await connection.query(table!, columns: columns, orderBy: orderBy);
    await connection.close();
    return rows;
  }

  Future<void> drop() async {
    final connection = await db();
    Get.consoleLog('droping table $table');
    await Future.delayed(const Duration(milliseconds: 2500), () async {
      await connection.execute('DROP TABLE IF EXISTS $table');
    });
    Get.consoleLog('table $table droped');
    await connection.close();
  }

  Future<dynamic> find(
    String id, {
    Function(Map<String, dynamic> result)? callback,
  }) async {
    final connection = await db();
    final row = await connection
        .query(
          table!,
          where: '$primaryKey = ?',
          whereArgs: [id],
          limit: 1,
        )
        .then((value) => value.first);

    if (callback != null) return callback(row);
    return row;
  }
}

abstract class SQLDatabase {
  String? table;
  String? definition;
  String? primaryKey;
}
