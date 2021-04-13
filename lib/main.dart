import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mercado/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: "Mercado",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.grey[900],
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
    home: Splash(),
  ));
}
