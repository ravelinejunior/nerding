import 'package:flutter/material.dart';
import 'package:nerding/screens/login_screen/components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginBody(),
        top: true,
      ),
    );
  }
}
