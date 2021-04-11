import 'package:flutter/material.dart';
import 'home.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
            seconds: 5,
            backgroundColor: Colors.grey[900],
            navigateAfterSeconds: Home(),
            title: new Text(
              'Lista de Mercado Digital',
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.amber[800]),
            ),
            loaderColor: Color(0xff056162),
            image: new Image.asset("assets/icon/icon.png"),
            photoSize: 80.0),
      ],
    );
  }
}
