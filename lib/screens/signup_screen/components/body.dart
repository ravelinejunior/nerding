import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nerding/screens/dialog_box_screen/loadingDialog_screen.dart';
import 'package:nerding/screens/login_screen/login_screen.dart';
import 'package:nerding/screens/signup_screen/components/background.dart';
import 'package:nerding/utils/already_have_an_account_acheck.dart';
import 'package:nerding/utils/rounded_button.dart';
import 'package:nerding/utils/rounded_input_field.dart';
import 'package:nerding/utils/rounded_password_field.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({Key? key}) : super(key: key);

  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String userPhotoUrl = "";

  File? _imageIo;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return SignupBackgroundBody(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _chooseImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.20,
                backgroundColor: Colors.deepOrange[100],
                backgroundImage: _imageIo != null ? FileImage(_imageIo!) : null,
                child: _imageIo != null
                    ? null
                    : Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.20,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            RoundedInputField(
              hintText: 'Name',
              action: TextInputAction.next,
              icon: Icons.person,
              onChanged: (value) {
                _nameController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Email',
              action: TextInputAction.next,
              icon: Icons.email,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Phone',
              action: TextInputAction.next,
              icon: Icons.phone_android,
              onChanged: (value) {
                _phoneController.text = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            RoundedButton(
              text: 'SIGNUP',
              press: () {},
              color: Colors.deepOrange,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
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

  _chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    try {
      File file = File(pickedFile!.path);
      setState(() {
        _imageIo = file;
      });
    } catch (error) {
      print(error);
    }
  }

  upload() async {
    showDialog(
      context: context,
      builder: (context) => LoadingAlertDialogScreen(),
    );

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storage = firebaseStorage.ref().child(fileName);
  }
}
