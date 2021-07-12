import 'package:flutter/material.dart';
import 'package:nerding/screens/welcome_screen/components/body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WelcomeBody(),
        top: true,
      ),
    );
  }
}
