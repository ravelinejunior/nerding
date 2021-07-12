import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nerding/screens/login_screen/components/background.dart';
import 'package:nerding/screens/signup_screen/signup_screen.dart';
import 'package:nerding/screens/welcome_screen/welcome_screen.dart';
import 'package:nerding/utils/already_have_an_account_acheck.dart';
import 'package:nerding/utils/rounded_button.dart';
import 'package:nerding/utils/rounded_input_field.dart';
import 'package:nerding/utils/rounded_password_field.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            SvgPicture.asset(
              'assets/icons/login.svg',
              height: size.height * 0.35,
            ),
            const SizedBox(height: 16),
            RoundedInputField(
              hintText: 'Email',
              action: TextInputAction.next,
              icon: Icons.email,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            RoundedButton(
              text: 'LOGIN',
              press: () {},
              color: Colors.deepOrange,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SignupScreen();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
