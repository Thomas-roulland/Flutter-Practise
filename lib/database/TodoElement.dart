import 'package:hive/hive.dart';

part 'TodoElement.g.dart';

@HiveType(typeId: 1)
class TodoElement {
  TodoElement(this.name);

  @HiveField(0)
  late String name;

  @HiveField(1)
  late bool checked = false;
}
