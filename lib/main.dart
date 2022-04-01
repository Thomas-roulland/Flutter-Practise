import 'dart:io';
import 'package:firstapp/database/TodoElement.dart';
import 'package:firstapp/database/TodoList.dart';
import 'package:firstapp/pages/HomePage.dart';
import 'package:firstapp/pages/TodoListPage.dart';
import 'package:firstapp/providers/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';

void main() async {
  if (Platform.isWindows) {
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  Hive.registerAdapter(TodoElementAdapter());
  Hive.registerAdapter(TodoListAdapter());
  await Hive.openBox<TodoList>(MyApp.BOXNAME);
  runApp(ChangeNotifierProvider(
      create: (context) => TodoListModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const BOXNAME = 'todoList';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todos lists application',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/todos': (context) => const TodoListPage(title: 'Todos'),
      },
    );
  }
}
