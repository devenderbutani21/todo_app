import 'package:flutter/material.dart';

class RoundCheckboxButton extends StatelessWidget {
  final bool isCompleted;
  final MediaQueryData mediaQuery;

  const RoundCheckboxButton(this.isCompleted, this.mediaQuery);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.size.height/10,
      width: mediaQuery.size.width/10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? Color(0xff37d7b2) : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width/100),
        child: isCompleted
            ? Icon(
                Icons.check,
                size: mediaQuery.size.width/20,
                color: Colors.white,
              )
            : Icon(
                Icons.radio_button_unchecked,
                size: mediaQuery.size.width/10,
                color: Colors.black,
              ),
      ),
    );
  }
}
