import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget? child;
  const LoginBackground({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset(
              'assets/images/main_top.png',
              width: size.width * 0.30,
            ),
            top: 0,
            left: 0,
          ),
          Positioned(
            child: Image.asset(
              'assets/images/login_bottom.png',
              width: size.width * 0.30,
            ),
            bottom: 0,
            left: 0,
          ),
          child!,
        ],
      ),
    );
  }
}
