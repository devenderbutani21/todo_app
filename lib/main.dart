import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/roundCheckboxButton.dart';
import './widgets/text_widget.dart';
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
      title: 'Todo App',
      theme: ThemeData(
        primaryColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.white,
        ),
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

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final curScaleFactor = mediaQuery.textScaleFactor;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2000),
    //   lastDate: DateTime(2025),
    // );
    //
    // _selectDate(BuildContext context) async {
    //   final DateTime picked = await showDatePicker(
    //     context: context,
    //     initialDate: selectedDate, // Refer step 1
    //     firstDate: DateTime(2000),
    //     lastDate: DateTime(2025),
    //   );
    //   if (picked != null && picked != selectedDate)
    //     setState(() {
    //       selectedDate = picked;
    //     });
    // }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "All Tasks",
            style: TextStyle(
              fontSize: 26 * curScaleFactor,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
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
                  child: TextWidget(
                    option,
                    FontWeight.bold,
                    18,
                    TextAlign.center,
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
              height: mediaQuery.size.height / 60,
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
                return Container(
                  height: mediaQuery.size.height,
                  padding: EdgeInsets.only(
                    bottom: mediaQuery.size.height / 100,
                  ),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final TodoModel todo = todos.get(key);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(mediaQuery.size.width / 8),
                          border: Border.all(color: Colors.grey.shade500),
                        ),
                        child: ListTile(
                          title: TextWidget(
                            todo.title,
                            FontWeight.w700,
                            22,
                            TextAlign.left,
                          ),
                          subtitle: TextWidget(
                            todo.detail,
                            FontWeight.w700,
                            18,
                            TextAlign.left,
                          ),
                          trailing: RoundCheckboxButton(
                            todo.isCompleted,
                            mediaQuery,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      mediaQuery.size.width / 16),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(
                                      mediaQuery.size.width / 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              flex: 17,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: TextWidget(
                                                  "What do you want to do?",
                                                  FontWeight.bold,
                                                  18,
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size:
                                                    mediaQuery.size.width / 25,
                                              ),
//                                            iconSize: 1,
                                              alignment: Alignment.topRight,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          FlatButton(
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: TextWidget(
                                                "Delete Item",
                                                FontWeight.bold,
                                                mediaQuery.size.width < 350
                                                    ? 14 * 0.7
                                                    : 14,
                                                TextAlign.center,
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
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: TextWidget(
                                                "Mark Complete",
                                                FontWeight.bold,
                                                mediaQuery.size.width < 350
                                                    ? 14 * 0.7
                                                    : 14,
                                                TextAlign.center,
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
                  ),
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
                borderRadius: BorderRadius.circular(mediaQuery.size.width / 16),
              ),
              child: Container(
                padding: EdgeInsets.all(mediaQuery.size.width / 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Title",
                        labelStyle: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18 * curScaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: titleController,
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 18 * curScaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.width / 32,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Detail",
                        labelStyle: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18 * curScaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: detailController,
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 18 * curScaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.width / 32,
                    ),
                    MaterialButton(
                      onPressed: () {
                        // _selectDate(context);
                      },
                      child: Text('Add Date'),
                    ),
                    FlatButton(
                      child: TextWidget(
                        "Add",
                        FontWeight.bold,
                        18,
                        TextAlign.center,
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
                        titleController.clear();
                        detailController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
