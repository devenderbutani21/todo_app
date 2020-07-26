import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widget/roundCheckboxButton.dart';
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

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  TodoFilter filter = TodoFilter.ALL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
  }

  TextStyle styleText = TextStyle(
    fontFamily: 'Nunito Sans',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Center(
            child: Text(
              "All Tasks",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              color: Colors.white70,
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
                    child: Text(
                      option,
                      style: styleText,
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
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

                      return Container(
//                        decoration: BoxDecoration(
//
//                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(color: Colors.grey.shade500),
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            todo.detail,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          trailing: RoundCheckboxButton(todo.isCompleted),
                          onTap: () {
                            showDialog(
                              context: context,
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              "What do you want to do?",
                                              style: styleText,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                            iconSize: 15,
                                            alignment: Alignment.topRight,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Delete Item",
                                              style: TextStyle(
                                                fontFamily: 'Nunito Sans',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                todoBox.delete(key);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Mark As Completed",
                                              style: TextStyle(
                                                fontFamily: 'Nunito Sans',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              TodoModel mTodo = TodoModel(
                                                title: todo.title,
                                                detail: todo.detail,
                                                isCompleted: true,
                                              );
                                              setState(() {
                                                todoBox.put(key, mTodo);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xff37d7b2),
          onPressed: () {
            showDialog(
              context: context,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Title",
                          labelStyle: styleText,
                        ),
                        controller: titleController,
                        style: styleText,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Detail",
                          labelStyle: styleText,
                        ),
                        controller: detailController,
                        style: styleText,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FlatButton(
                        child: Text(
                          "Add",
                          style: styleText,
                        ),
                        onPressed: () {
                          String title = titleController.text;
                          String detail = detailController.text;

                          TodoModel todo = TodoModel(
                            title: title,
                            detail: detail,
                            isCompleted: false,
                          );
                          setState(() {
                            todoBox.add(todo);
                            Navigator.of(context).pop();
                          });
                          titleController = null;
                          detailController = null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
