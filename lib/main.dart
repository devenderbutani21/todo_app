import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<String>("todoitem");
  await Hive.openBox<String>("dateitem");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        canvasColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget{
  @override
  createState() => TodoListState();
}

class TodoListState extends State<TodoList> {

  Box<String> todoItemBox;
  Box<String> todoDateItemBox;

  List<String> _todoItems = [];
  List<String> _dateTimeItems = [];
  // Add to list and build-list section
  void _addTodoItem(String task, String date) {
    todoItemBox = Hive.box<String>("todoitem");
    todoDateItemBox = Hive.box<String>("dateitem");
    if(task.length > 0 ) {
      setState(() {
        todoItemBox.add(task);
        todoDateItemBox.add(date);
        _todoItems.add(task);
        _dateTimeItems.add(date);
      });
    }
  }

  Widget _buildTodoList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          if(index < _todoItems.length) {
            return _buildTodoItem( _todoItems[index], index, _dateTimeItems[index]);
          }
        },
    );
  }

  Widget _buildTodoItem(String todoText, int index, String dateText) {
    return Card (
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(5.0),
//      ), // for rounding the card
      color: Colors.lightBlueAccent,
      child: ListTile(
        title: Text(
            dateText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
            todoText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        onTap: () => _promptRemoveTodoItem(index),
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push (
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Add a new task',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  fontFamily: 'Nunito Sans',
                ),
              ),
            ),
            body: TextField(
              autofocus: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              onSubmitted: (val) {
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('dd/MM/yyyy').format(now);
                _addTodoItem(val, formattedDate,);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: 'Enter Something to do',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16.0)
              ),
            )
          );
        })
    );
  }

  // Remove from list section
  void _removeTodoItem(int index) {
    setState(() {
      todoItemBox.delete(index);
      todoDateItemBox.delete(index);
      _todoItems.removeAt(index);
      _dateTimeItems.removeAt(index);
    });
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          title: Text (
            'Mark "${todoItemBox.getAt(index)}" as done?',
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CANCEL',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text(
                  'MARK AS DONE',
                   style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Todo List',
        style: TextStyle(
          fontSize: 26,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w700,
        ),
        ),
    ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }
}


