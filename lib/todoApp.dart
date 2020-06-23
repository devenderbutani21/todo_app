import 'package:flutter/material.dart';
import 'package:todoapp/widget/roundCheckboxButton.dart';

class TodoApp extends StatefulWidget {
  @override
  TodoAppState createState() => TodoAppState();
}

class TodoAppState extends State<TodoApp>{
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text('All Tasks',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('One-line with trailing widget',
                style: _value ?
                      TextStyle()
                    : TextStyle( decoration: TextDecoration.lineThrough,),
              ),
                trailing: RoundCheckboxButton(),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 75,
          width: 75,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
              backgroundColor: Color(0xff5ca8e0),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}























