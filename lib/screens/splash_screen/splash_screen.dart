import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nerding/screens/home_screen/home_screen.dart';
import 'package:nerding/screens/welcome_screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(Duration(seconds: 3), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Route newRoute = MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
        Navigator.of(context).pushReplacement(newRoute);
      } else {
        Route newRoute = MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        );
        Navigator.of(context).pushReplacement(newRoute);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange[700]!,
              Colors.deepOrange[700]!,
            ],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(1, 1),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Compre, Venda ou Troque suas coisas por coisas novas. #SaiDessa',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: 'Lobster-Regular',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
