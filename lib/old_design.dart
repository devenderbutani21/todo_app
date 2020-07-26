//import 'dart:ui';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
//import 'package:path_provider/path_provider.dart' as path_provider;
//import 'package:shared_preferences/shared_preferences.dart';
//
//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
//  runApp(MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Todo List',
//      theme: ThemeData(
//        primarySwatch: Colors.lightBlue,
//        canvasColor: Colors.white,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: TodoList(),
//    );
//  }
//}
//
//
//class TodoList extends StatefulWidget{
//  @override
//  createState() => TodoListState();
//}
//
//class TodoListState extends State<TodoList> {
//
//  List<String> _todoItems = [];
//  List<String> _dateTimeItems = [];
////  List<String> myList = [];
//  // Add to list and build-list section
//
//  // Save in Shared Preference
//  _save() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      _todoItems  = (prefs.getStringList('mylist') ?? List<String>()) ;
//    });
////    List<int> myOriginaList = myList.map((i)=> int.parse(i)).toList();
//    print('Your list  $_todoItems');
//    await prefs.setStringList('mylist', _todoItems);
//  }
//
//  void _addTodoItem(String task, String date) {
//    if(task.length > 0 ) {
//      setState(() {
//        _todoItems.add(task);
//        _dateTimeItems.add(date);
//      });
//    }
//  }
//
//  Widget _buildTodoList() {
//    return ListView.builder(
//        itemBuilder: (context, index) {
//          if(index < _todoItems.length) {
//            return _buildTodoItem( _todoItems[index], index, _dateTimeItems[index]);
//          }
//        },
//    );
//  }
//
//  Widget _buildTodoItem(String todoText, int index, String dateText) {
//    return Card (
////      shape: RoundedRectangleBorder(
////        borderRadius: BorderRadius.circular(5.0),
////      ), // for rounding the card
//      color: Colors.lightBlueAccent,
//      child: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [
//                Colors.blue,
//                Colors.blueAccent,
//            ],
//          ),
//        ),
//        child: ListTile(
//          title: Text(
//              dateText,
//            style: TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 12,
//            ),
//          ),
//          subtitle: Text(
//              todoText,
//            style: TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 24,
//              color: Colors.black,
//            ),
//          ),
//          onTap: () => _promptRemoveTodoItem(index),
//        ),
//      ),
//    );
//  }
//
//  void _pushAddTodoScreen() {
//    Navigator.of(context).push (
//      MaterialPageRoute(
//        builder: (context) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'Add a new task',
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 26,
//                  fontFamily: 'Nunito Sans',
//                ),
//              ),
//            ),
//            body: TextField(
//              autofocus: true,
//              style: TextStyle(
//                fontWeight: FontWeight.bold,
//                fontSize: 24,
//              ),
//              onSubmitted: (val) {
//                DateTime now = DateTime.now();
//                String formattedDate = DateFormat('dd/MM/yyyy').format(now);
//                _addTodoItem(val, formattedDate,);
//                _save();
//                Navigator.pop(context);
//              },
//              decoration: InputDecoration(
//                hintText: 'Enter Something to do',
//                  border: InputBorder.none,
//                  contentPadding: const EdgeInsets.all(16.0)
//              ),
//            )
//          );
//        })
//    );
//  }
//
//
//  // Remove from list section
//  void _removeTodoItem(int index) {
//    setState(() {
//      _todoItems.removeAt(index);
//      _dateTimeItems.removeAt(index);
//    });
//  }
//
//  void _promptRemoveTodoItem(int index) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog (
//          title: Text (
//            'Mark "${_todoItems[index]}" as done?',
//            style: TextStyle(
//              fontFamily: 'Nunito Sans',
//              fontSize: 24,
//              fontWeight: FontWeight.bold,
//            )
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text(
//                'CANCEL',
//                  style: TextStyle(
//                    fontFamily: 'Nunito Sans',
//                    fontSize: 18,
//                    fontWeight: FontWeight.bold,
//                  )
//              ),
//              onPressed: () => Navigator.of(context).pop(),
//            ),
//            FlatButton(
//              child: Text(
//                  'MARK AS DONE',
//                   style: TextStyle(
//                    fontFamily: 'Nunito Sans',
//                    fontSize: 18,
//                    fontWeight: FontWeight.bold,
//                  )
//              ),
//              onPressed: () {
//                _removeTodoItem(index);
//                Navigator.of(context).pop();
//              },
//            )
//          ],
//        );
//      }
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//    ]);
//    return Scaffold(
//        appBar: AppBar(
//        title: Text('Todo List',
//        style: TextStyle(
//          fontSize: 26,
//          fontFamily: 'Nunito Sans',
//          fontWeight: FontWeight.w700,
//        ),
//        ),
//    ),
//      body: _buildTodoList(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _pushAddTodoScreen,
//        tooltip: 'Add task',
//        child: Icon(Icons.add),
//      ),
//    );
//  }
//}