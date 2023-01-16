import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core.dart';
import 'package:todo_app/tables/todos_table.dart';

class TodosController extends State<TodosView> implements MvcController {
  static late TodosController instance;
  late TodosView view;

  final TodoTable todo = TodoTable();

  final title = TextEditingController();
  final content = TextEditingController();
  final description = TextEditingController();

  bool notIsEmpty(TextEditingController name) => name.text.isNotEmpty;

  String convertDatetime(String dateTime) => DateFormat(
        'yyyy-MM-dd H:m:s',
      ).format(DateTime.parse(dateTime));

  void cleanUp() {
    for (TextEditingController e in [title, description, content]) {
      e.clear();
    }
  }

  Map<String, dynamic> get item => {
        'title': title.text,
        'content': content.text,
        'description': description.text,
        'createdAt': DateTime.now().toString(),
      };

  Future<int> save() async {
    if (!notIsEmpty(title)) {
      return 0;
    }
    return await todo.createItem(values: item);
  }

  void filled(String id) async {
    final row = await todo.find(id, callback: (result) {
      return Todos(
        id: result['id'],
        title: result['title'],
        description: result['description'],
        content: result['content'],
        createdAt: result['createdAt'].toString(),
      );
    }) as Todos;

    title.text = row.title;
    content.text = row.content;
    description.text = row.description;
  }

  void initTable() async => await todo.createDatabase();

  Future<List<Todos?>> refreshTodo() async {
    List<Todos> todoList = [];
    await Future.delayed(const Duration(milliseconds: 1500));
    final data = await todo.all(orderBy: 'createdAt desc');
    for (Map<String, dynamic> el in data) {
      todoList.add(
        Todos(
          id: el['id'],
          description: el['description'],
          content: el['content'],
          title: el['title'],
          createdAt: el['createdAt'].toString(),
        ),
      );
    }
    return todoList;
  }

  @override
  void initState() {
    instance = this;
    initTable();
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
