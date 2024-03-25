import 'package:crypto_viewer/pages/crypto_view_sreen.dart';
import 'package:crypto_viewer/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'services/firebase_service.dart';

void readData() {
  DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('credential');

  databaseReference.onValue.listen((event) {
    DataSnapshot dataSnapshot = event.snapshot;

    var id = dataSnapshot.key;
    var email = (dataSnapshot.child("email").value.toString());
    var name =  (dataSnapshot.child("name").value.toString());
    var pass =  (dataSnapshot.child("pass").value.toString());

    print('id=> ${id}');
    print('id=> ${name}');
    print('id=> ${email}');
    print('id=> ${pass}');
    // Map<dynamic, dynamic> values = dataSnapshot;
    // values.forEach((key, values) {
    //   print('Key: $key');
    //   print('Name: ${values['name']}');
    //   print('Email: ${values['email']}');
    //   print('pass: ${values['pass']}');
    // });
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await FirebaseService().initialize();

  //final DatabaseReference _db = FirebaseService().databaseRef.child('users');
  //readData();

  runApp(const MyApp());
}

/*

* apiKey: "AIzaSyDMkhBCTGRSXLfUbidkcKZQjpUOw2cN-h4",
        appId: "1:984096563848:web:d874427197c36b1464f53d",
        messagingSenderId: "984096563848",
        projectId: "crypto2-98a60",
*
* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      color: Colors.grey[300],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 36, 41, 175)),
        useMaterial3: true,
      ),
      
      initialRoute: "/",
      routes:{
        "/":(context) => const SplashScreen(),
        "crypto_view_screen":(context) => const CryptoViewScreen(),
      },
    );
  }
}

