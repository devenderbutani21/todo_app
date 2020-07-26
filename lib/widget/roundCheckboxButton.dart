import 'package:flutter/material.dart';

class RoundCheckboxButton extends StatelessWidget {
  final bool isCompleted;

  const RoundCheckboxButton(this.isCompleted);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? Color(0xff37d7b2) : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: isCompleted
            ? Icon(
                Icons.check,
                size: 15.0,
                color: Colors.white,
              )
            : Icon(
                Icons.radio_button_unchecked,
                size: 30.0,
                color: Colors.black,
              ),
      ),
    );
  }
}
