import 'package:flutter/material.dart';

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
            Navigator.of(context).pop();
          },
          child: Center(
            child: Text('OK'),
          ),
        )
      ],
    );
  }
}
