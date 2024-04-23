
import 'package:flutter/material.dart';

import '../pages/mywallet_view_screen.dart';
import 'box_decoration.dart';
class CutomeAlert{
  static dynamic showAlert(dynamic context, String massage){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:Colors.orange[700],
        title: const Text("Fail", style: TextStyle(color: Colors.white),),
        content: Text(massage, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
              decoration: BoxDecoration(
                color: Colors.orange[700]!,
                borderRadius: BorderRadius.circular(25.0),
                border: BoxDecoratinStyes.CustomeBorder,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange[200]!,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.orange[500]!,
                    offset: Offset(3.0, 4.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  static dynamic showErrorAlert(dynamic context, String massage){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:Colors.red[700],
        title: const Text("Error", style: TextStyle(color: Colors.white),),
        content: Text(massage, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
              decoration: BoxDecoration(
                color: Colors.red[700]!,
                borderRadius: BorderRadius.circular(25.0),
                border: BoxDecoratinStyes.CustomeBorder,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red[400]!,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.red[500]!,
                    offset: Offset(3.0, 4.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
  static dynamic showSuccessAlert(dynamic context, String massage){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:Colors.green[700],
        title: const Text("Success", style: TextStyle(color: Colors.white)),
        content: Text(massage, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () async{
              return;
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
              decoration: BoxDecoration(
                color: Colors.green[400]!,
                borderRadius: BorderRadius.circular(25.0),
                border: BoxDecoratinStyes.CustomeBorder,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green[200]!,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.green[700]!,
                    offset: Offset(3.0, 4.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}