import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nerding/screens/login_screen/login_screen.dart';
import 'package:nerding/screens/signup_screen/signup_screen.dart';
import 'package:nerding/screens/welcome_screen/components/background.dart';
import 'package:nerding/utils/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nerding',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Signatra',
                fontSize: 72,
                color: Colors.deepOrange[200],
              ),
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(
              'assets/icons/chat.svg',
              height: size.height * 0.40,
            ),
            const SizedBox(height: 16),
            RoundedButton(
              text: 'LOGIN',
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: 'SIGNUP',
              color: Colors.deepOrange[100]!,
              textColor: Colors.black,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
