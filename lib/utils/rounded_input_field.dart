import 'package:flutter/material.dart';
import 'package:nerding/utils/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final TextInputAction? action;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.action,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.deepOrange,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.deepOrange,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        textInputAction: action,
      ),
    );
  }
}
