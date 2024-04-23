import 'package:crypto_viewer/pages/crypto_view_sreen.dart';
import 'package:crypto_viewer/pages/login_view_screen.dart';
import 'package:crypto_viewer/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();

  factory FirebaseService() => _instance;

  FirebaseService._();

  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  DatabaseReference get databaseRef => FirebaseDatabase.instance.reference();
}

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({String email="", String password="" }) async {
    if(email == "" || email == null || email.length <=5 || !email.contains("@")){
      print("-------------------register in email null-----------------\n\n");

      return ;
    }
    if(password == ""|| password == null || password.length <=5){
      print("-------------------register in pass null-----------------\n\n");

      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("-------------------register success-----------------\n\n");

      return;
    } on FirebaseAuthException catch (e) {
      return;
    }
  }

  //SIGN IN METHOD
  Future signIn({String email="", String password="" }) async {
    if(email == "" || email == null || email.length <=5 || !email.contains("@")){
      print("-------------------sign in email null-----------------\n\n");

      return;
    }
    if(password == ""|| password == null || password.length <=5){
      print("-------------------sign in pass null-----------------\n\n");
      return ;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("-------------------sign in try-----------------\n\n");
      return ;
    } on FirebaseAuthException catch (e) {
      print("-------------------sign in exception ${e}-----------------\n\n");
      return ;
    }
  }

  //SIGN OUT METHOD
  Future signOut(var context) async {
    await _auth.signOut();
    print("-------------------sign out done-----------------\n\n");

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));

  }

  Future<bool> isAuthenticated(var context) async{
    bool isauthenticated = false;
    var user = _auth.currentUser;
    if(user!=null){
      Navigator.pushReplacement(
        context,
        await MaterialPageRoute(builder: (context) => CryptoViewScreen()),

      );
      isauthenticated=true;
    }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
      isauthenticated=false;

      // Navigator.pushReplacement(
      //   context,
      //   await MaterialPageRoute(builder: (context) => LoginScreen()),
      // );
    }
    return isauthenticated;
  }

}

