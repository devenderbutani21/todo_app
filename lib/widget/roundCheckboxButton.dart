import 'package:flutter/material.dart';

class RoundCheckboxButton extends StatelessWidget {
  final bool isCompleted;
  final MediaQueryData mediaQuery;

  const RoundCheckboxButton(this.isCompleted, this.mediaQuery);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.size.height/16,
      width: mediaQuery.size.width/16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? Color(0xff37d7b2) : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width/125),
        child: isCompleted
            ? Icon(
                Icons.check,
                size: mediaQuery.size.width/25,
                color: Colors.white,
              )
            : Icon(
                Icons.radio_button_unchecked,
                size: mediaQuery.size.width/16,
                color: Colors.black,
              ),
      ),
    );
  }
}
