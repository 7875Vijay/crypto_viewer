import 'dart:async';

import 'package:crypto_viewer/pages/crypto_view_sreen.dart';
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
  void initState()async{
    super.initState();
    await Timer(const Duration(seconds: 3), () {}
    );
    await AuthenticationHelper().isAuthenticated(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/splash.png", fit: BoxFit.cover,),),
    );
  }
}