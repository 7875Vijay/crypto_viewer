import 'package:flutter/material.dart';

class CustomeElevatedButtonStyle{
  static dynamic customeStyle(var backgroundColor, var textColor, var shadowColor){
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shadowColor: shadowColor,
        padding: EdgeInsets.all(5.0),
        );
  }

}