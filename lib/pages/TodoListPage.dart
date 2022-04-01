import 'package:firstapp/database/TodoElement.dart';
import 'package:firstapp/providers/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TodoListPage> createState() => _TodoListPage();
}

class _TodoListPage extends State<TodoListPage> {
  int _counter = 0;
  String valueText = '';

  Future<String?> addItemDialog([int index = -1]) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Ajouter un champs'),
        content: Consumer<TodoListModel>(builder: (context, todoList, child) {
          return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Checkbox(
                value: todoList.getItem(index).checked,
                onChanged: (value) {
                  todoList.toggleCheck(index);
                }),
            Flexible(
              child: TextFormField(
                autofocus: true,
                initialValue: (index == -1) ? '' : todoList.getItem(index).name,
                onChanged: (value) {
                  valueText = value;
                },
                decoration: InputDecoration(hintText: "titatu"),
              ),
            )
          ]);
        }),
        actions: <Widget>[
          FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text('CANCEL'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          Consumer<TodoListModel>(builder: (context, todolist, child) {
            return FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () {
                todolist.insertOrUpdate(index, valueText);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Consumer<TodoListModel>(builder: (context, todolist, child) {
          todolist.setActiveList(listName);
          List<TodoElement> todoItems = todolist.todo;
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: todoItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.whatshot),
                    Checkbox(
                        value: todoItems[index].checked,
                        onChanged: (value) {
                          todolist.toggleCheck(index);
                        }),
                  ]),
                  title: Text(todoItems[index].name),
                  dense: false,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.create),
                        onPressed: () {
                          addItemDialog(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          todolist.remove(index);
                        },
                      )
                    ],
                  ),
                );
              });
        }),
        floatingActionButton: Stack(children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: FloatingActionButton(
                onPressed: addItemDialog,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child:
                  Consumer<TodoListModel>(builder: (context, todolist, child) {
                return FloatingActionButton(
                    child: const Icon(Icons.clear),
                    onPressed: () {
                      todolist.clear();
                    });
              })),
        ]));
  }
}
