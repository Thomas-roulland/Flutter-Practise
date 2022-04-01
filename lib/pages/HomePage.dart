import 'package:firstapp/providers/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String valueText = '';

  Future<String?> addList(context, [int index = -1]) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Création d\'une liste'),
        content: Consumer<TodoListModel>(builder: (context, todoList, child) {
          return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
              Navigator.pop(context);
            },
          ),
          Consumer<TodoListModel>(builder: (context, todolist, child) {
            return FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () {
                todolist.addNewList(valueText);
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo Lists'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: new EdgeInsets.all(15),
                child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                    onPressed: () {
                      addList(context);
                    },
                    label: const Text('Nouvelle liste TODO'))),
            Consumer<TodoListModel>(builder: (context, todolist, child) {
              List<String> myList = todolist.listNames;
              return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: todolist.countList,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/todos',
                            arguments: myList[index]);
                      },
                      leading: Icon(Icons.lunch_dining),
                      title: Row(children: [
                        Text(myList[index]),
                        Text(" [ ${todolist.countElement(myList[index])} ]")
                      ]),
                      dense: false,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.create),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {},
                          )
                        ],
                      ),
                    );
                  });
            }),
          ],
        ));
  }
}
