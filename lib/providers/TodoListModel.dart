import 'package:firstapp/database/TodoElement.dart';
import 'package:firstapp/database/TodoList.dart';
import 'package:firstapp/main.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class TodoListModel extends ChangeNotifier {
  late String activeListName;

  TodoListModel() {
    Box box = Hive.box<TodoList>(MyApp.BOXNAME);
    List<TodoList> list = box.values.toList().cast();
    list.forEach((list) {
      myLists[list.name] = list.elements.cast<TodoElement>();
    });
  }

  late Map<String, List<TodoElement>> myLists = {};
  List<TodoElement> _todos = List.empty(growable: true);

  int? countElement(String name) {
    return myLists[name]?.length;
  }

  removeList(index) {
    myLists.remove(index);
    notifyListeners();
  }

  get listNames {
    return myLists.keys.toList();
  }

  bool addNewList(String name) {
    if (!myLists.containsKey(name)) {
      myLists[name] = List.empty(growable: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  get countList {
    return myLists.length;
  }

  setActiveList(String name) {
    if (myLists.containsKey(name)) {
      activeListName = name;
      _todos = myLists[name] as List<TodoElement>;
      notifyListeners();
    }
  }

  get todo {
    return _todos;
  }

  addItem(String item) {
    _todos.add(TodoElement(item));
    notifyListeners();
  }

  TodoElement getItem(int index) {
    if (index == -1) {
      return TodoElement('');
    }
    return _todos.elementAt(index);
  }

  toggleCheck(int index) {
    if (index != -1) {
      _todos[index].checked = !_todos[index].checked;
      notifyListeners();
    }
  }

  update(int index, String newValue) {
    _todos[index].name = newValue;
    notifyListeners();
  }

  insertOrUpdate(int index, String newValue) {
    if (index == -1) {
      addItem(newValue);
    } else {
      update(index, newValue);
    }
  }

  remove(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  clear() {
    _todos.clear();
    notifyListeners();
  }

  save() async {
    //Sauvegarder activeListName et ses items (myList)
    Box box = await Hive.openBox<TodoList>(MyApp.BOXNAME);
    TodoList list =
        box.values.firstWhere((element) => element.name == activeListName)
          ?..elements = _todos
          ..save();
  }
}
