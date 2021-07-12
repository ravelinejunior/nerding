import 'package:flutter/material.dart';
import 'package:nerding/screens/signup_screen/components/body.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGNUP'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SignupBody(),
        top: true,
      ),
    );
  }
}
