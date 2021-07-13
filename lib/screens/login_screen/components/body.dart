import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nerding/screens/dialog_box_screen/errorDialog_screen.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:nerding/screens/home_screen/home_screen.dart';
import 'package:nerding/screens/login_screen/components/background.dart';
import 'package:nerding/screens/login_screen/login_screen.dart';
import 'package:nerding/screens/signup_screen/signup_screen.dart';
import 'package:nerding/utils/already_have_an_account_acheck.dart';
import 'package:nerding/utils/global_vars.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');

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
              press: () {
                if (_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  _login();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorAlertDialogScreen(
                      message: 'Digite email e senha para logar.',
                    ),
                  );
                }
              },
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

  void _login() async {
    showDialog(
      context: context,
      builder: (_) => LoadingAlertDialogScreen(),
    );

    User? currentUser;

    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => ErrorAlertDialogScreen(
          message: error.message.toString(),
        ),
      );
    });

    if (currentUser != null) {
      getUserData(currentUser!.uid);
    } else {
      ErrorAlertDialogScreen(
        message: 'Erro ao logar!',
      );
    }
  }

  void getUserData(String uid) async {
    await userRef.doc(uid).get().then(
      (result) {
        Map<String, dynamic> data = result.data() as Map<String, dynamic>;
        String status = data[STATUS];
        if (status == "approved") {
          Navigator.of(context).pop();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          _auth.signOut();
          Navigator.of(context).pop();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );

          showDialog(
            context: context,
            builder: (context) => ErrorAlertDialogScreen(
              message: 'Esta conta foi bloqueada pelo administrador.',
            ),
          );
        }
      },
    );
  }
}
