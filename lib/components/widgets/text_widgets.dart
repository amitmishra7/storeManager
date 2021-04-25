import 'package:flutter/material.dart';

class TextWidgets extends StatelessWidget {
  String text;

  Color color;
  FontWeight fontWeight;
  double fontSize;
  double wordSpacing;
  double letterSpacing;
  TextAlign textAlign;
  String fontFamily;

  TextWidgets(
      {this.text,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.wordSpacing,
      this.textAlign,
      this.letterSpacing,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
          wordSpacing: wordSpacing,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily),
      textAlign: textAlign,
    );
  }
}

class MyText {
  static TextStyle display4(BuildContext context) {
    return Theme.of(context).textTheme.display4;
  }

  static TextStyle display3(BuildContext context) {
    return Theme.of(context).textTheme.display3;
  }

  static TextStyle display2(BuildContext context) {
    return Theme.of(context).textTheme.display2;
  }

  static TextStyle display1(BuildContext context) {
    return Theme.of(context).textTheme.display1;
  }

  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headline;
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.title;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.subhead.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle subhead(BuildContext context) {
    return Theme.of(context).textTheme.subhead;
  }

  static TextStyle body2(BuildContext context) {
    return Theme.of(context).textTheme.body2;
  }

  static TextStyle body1(BuildContext context) {
    return Theme.of(context).textTheme.body1;
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.caption;
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.button;
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle;
  }

  static TextStyle overline(BuildContext context) {
    return Theme.of(context).textTheme.overline;
  }
}
