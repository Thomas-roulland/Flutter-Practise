import 'package:firstapp/models/Todo.dart';
import 'package:flutter/widgets.dart';

class TodoListModel extends ChangeNotifier {
  Map<String, List<Todo>> myLists = {
    'Mes courses': [
      Todo(name: 'Pain burger'),
      Todo(name: 'Steach Haché (10% matière grasse)'),
      Todo(name: 'Tranche de Cheddar'),
      Todo(name: 'Cornichons'),
      Todo(name: 'Ketchup')
    ]
  };
  List<Todo> _todos = List.empty(growable: true);

  addItem(String item) {
    _todos.add(Todo(name: item));
    notifyListeners();
  }

  clear() {
    _todos.clear();
    notifyListeners();
  }

  setActiveList(String name) {
    if (myLists.containsKey(name)) {
      _todos = myLists[name] as List<Todo>;
      notifyListeners();
    }
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

  get counList {
    return myLists.length;
  }

  int? countTodo(String name) {
    return myLists[name]?.length;
  }

  toggleChecked(int index) {
    if (index != -1) {
      _todos[index].checked = !_todos[index].checked;
      notifyListeners();
    }
  }

  remove(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  InsetOrUpdate(int index, String newValue) {
    if (index == -1) {
      addItem(newValue);
    } else {
      update(index, newValue);
    }
  }

  get todos {
    return _todos;
  }

  Todo getItem(int index) {
    if (index == -1) {
      return Todo(name: '');
    }
    return _todos.elementAt(index);
  }

  update(int index, String newValue) {
    _todos[index] = Todo(name: newValue);
    notifyListeners();
  }
}
