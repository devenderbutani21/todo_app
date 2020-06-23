import 'package:flutter/material.dart';

class RoundCheckboxButton extends StatefulWidget{
  @override
  RoundCheckboxButtonState createState() => RoundCheckboxButtonState();
}

class RoundCheckboxButtonState extends State<RoundCheckboxButton>{
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _value = !_value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _value?
          Color(0xff37d7b2)
              :Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _value
              ? Icon(
            Icons.check,
            size: 30.0,
            color: Colors.white,
          )
              : Icon(
            Icons.check_box_outline_blank,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}