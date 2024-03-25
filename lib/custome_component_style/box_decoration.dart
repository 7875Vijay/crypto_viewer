import 'package:flutter/material.dart';
class BoxDecoratinStyes {
  static var CustomeBoxshadow = [
    BoxShadow(
      color: const Color.fromARGB(255, 192, 191, 191),
      offset: const Offset(
        4.0,
        4.0,
      ),
      blurRadius: 5.0,
      spreadRadius: 5.0,
    ), //BoxShadow
    BoxShadow(
      color: Colors.white,
      offset: const Offset(-4, -4),
      blurRadius: 5.0,
      spreadRadius: 2.0,
    ), //BoxShadow
  ];

  static var CustomeBorder = Border.all(
      color: Colors.white,
      width: 2.0,
      style: BorderStyle.solid
  );
}