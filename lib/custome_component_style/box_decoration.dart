// import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/material.dart' ;

class BoxDecoratinStyes {
  static var CustomeBoxshadow = [
    BoxShadow(
      color: Color.fromARGB(255, 192, 191, 191),
      offset: const Offset(
        4.0,
        4.0,
      ),
      blurRadius: 5.0,
      spreadRadius: 5.0,
    ), //BoxShadow
    BoxShadow(
      color: Color.fromARGB(255,255,255,255),
      offset: const Offset(-4, -4),
      blurRadius: 5.0,
      spreadRadius: 2.0,
    ), //BoxShadow
  ];


  static var CustomeBorder = Border.all(
      color: Color.fromARGB(255,255,255,255),
      width: 2.0,
      style: BorderStyle.solid
  );



  // static var CustomeBoxshadowInset = [
  //   BoxShadow(
  //     offset: Offset(-20, -20),
  //     blurRadius: 30,
  //     color: Color(0xFF9F9E9E),
  //     inset: true,
  //   ),
  //   BoxShadow(
  //     offset: Offset(20, 20),
  //     blurRadius: 30,
  //     color: Color.fromARGB(255, 255, 255, 255),
  //     inset: true,
  //   ),
  // ];
}