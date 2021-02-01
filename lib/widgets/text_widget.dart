import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  String _text;
  FontWeight _fontWeight;
  double _fontSize;
  TextAlign _textAlign;

  TextWidget(
    this._text,
    this._fontWeight,
    this._fontSize,
    this._textAlign,
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final curScaleFactor = mediaQuery.textScaleFactor;
    return Text(
      this._text,
      style: TextStyle(
        fontSize: _fontSize * curScaleFactor,
        fontFamily: 'Nunito Sans',
        fontWeight: this._fontWeight,
      ),
      textAlign: this._textAlign,
    );
  }
}
