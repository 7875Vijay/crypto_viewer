import 'package:crypto_viewer/pages/crypto_view_sreen.dart';
import 'package:crypto_viewer/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

