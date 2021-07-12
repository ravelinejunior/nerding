import 'package:flutter/material.dart';
import 'package:nerding/screens/welcome_screen/welcome_screen.dart';

class ErrorAlertDialogScreen extends StatelessWidget {
  final String? message;
  const ErrorAlertDialogScreen({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ),
            );
          },
          child: Center(
            child: Text('OK'),
          ),
        )
      ],
    );
  }
}
