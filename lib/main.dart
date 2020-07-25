import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'todo_model.dart';

const String todoBoxName = "todo";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(todoBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TodoFilter { ALL, COMPLETED, INCOMPLETE }

class _MyHomePageState extends State<MyHomePage> {
  Box<TodoModel> todoBox;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  TodoFilter filter = TodoFilter.ALL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hive Todo"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value.compareTo("All") == 0) {
                  setState(() {
                    filter = TodoFilter.ALL;
                  });
                } else if (value.compareTo("Completed") == 0) {
                  setState(() {
                    filter = TodoFilter.COMPLETED;
                  });
                } else {
                  setState(() {
                    filter = TodoFilter.INCOMPLETE;
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return ["All", "Completed", "Incomplete"].map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            ),
          ],
        ),

        body: Column(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: todoBox.listenable(),
              builder: (context, Box<TodoModel> todos, _) {
                List<int> keys;

                if (filter == TodoFilter.ALL) {
                  keys = todos.keys.cast<int>().toList();
                } else if (filter == TodoFilter.COMPLETED) {
                  keys = todos.keys
                      .cast<int>()
                      .where((key) => todos.get(key).isCompleted)
                      .toList();
                } else {
                  keys = todos.keys
                      .cast<int>()
                      .where((key) => !todos.get(key).isCompleted)
                      .toList();
                }

                return ListView.separated(
                  itemBuilder: (_, index) {
                    final int key = keys[index];
                    final TodoModel todo = todos.get(key);

                    return ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(fontSize: 24),
                      ),
                      subtitle: Text(
                        todo.detail,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(
                        Icons.check,
                        color: todo.isCompleted ? Colors.green : Colors.red,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          child: Dialog(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text("Mark as completed"),
                                    onPressed: () {
                                      TodoModel mTodo = TodoModel(
                                        title: todo.title,
                                        detail: todo.detail,
                                        isCompleted: true,
                                      );
                                      todoBox.put(key, mTodo);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, index) => Divider(),
                  itemCount: keys.length,
                  shrinkWrap: true,
                );
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              child: Dialog(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(hintText: "Title"),
                        controller: titleController,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Detail"),
                        controller: detailController,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FlatButton(
                        child: Text("Add Todo"),
                        onPressed: () {
                          final String title = titleController.text;
                          final String detail = detailController.text;

                          TodoModel todo = TodoModel(
                            title: title,
                            detail: detail,
                            isCompleted: false,
                          );

                          todoBox.add(todo);

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

// For UI testing
//import 'package:flutter/material.dart';
//import 'package:todoapp/todoApp.dart';
//import 'package:flutter/services.dart' ;
//
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//    ]);
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: TodoApp(),
//    );
//  }
//}
