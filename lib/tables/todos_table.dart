import 'package:todo_app/tables/sql_helper.dart';

class TodoTable extends SQLHelper implements SQLDatabase {
  @override
  String? table = 'todos';

  @override
  String? definition = """id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    content TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP""";

  @override
  String? primaryKey = 'id';
}
