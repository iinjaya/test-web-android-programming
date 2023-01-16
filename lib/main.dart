import 'package:todo_app/core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO APP',
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const TodosView(),
    );
  }
}
