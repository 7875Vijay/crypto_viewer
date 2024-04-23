import 'dart:async';

import 'package:crypto_viewer/pages/crypto_view_sreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import 'login_view_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
     Timer(const Duration(seconds: 3), ()async {
      await AuthenticationHelper().isAuthenticated(context);
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0,0,0,0),
      body: Center(child: Image.asset("assets/images/newlogo.png", fit: BoxFit.cover,),),
    );
  }
}