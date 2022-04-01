import 'package:firstapp/database/TodoElement.dart';
import 'package:hive/hive.dart';

part 'TodoList.g.dart';

@HiveType(typeId: 1)
class TodoList {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List<TodoElement> elements = List<TodoElement>.empty(growable: true);
}
