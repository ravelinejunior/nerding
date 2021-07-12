import 'package:flutter/material.dart';
import 'package:nerding/utils/loadingWidget.dart';

class LoadingAlertDialogScreen extends StatelessWidget {
  final String? message;
  const LoadingAlertDialogScreen({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 12),
          const Text('PLEASE WAIT ...')
        ],
      ),
    );
  }
}
