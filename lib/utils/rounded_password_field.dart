import 'package:flutter/material.dart';
import 'package:nerding/utils/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const RoundedPasswordField({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Colors.deepOrange,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.deepOrange,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.deepOrange,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
