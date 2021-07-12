import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  final Widget? child;
  const WelcomeBackground({Key? key, this.child}) : super(key: key);

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
              width: size.width * 0.3,
            ),
            top: 0,
            left: 0,
          ),
          Positioned(
            child: Image.asset(
              'assets/images/main_bottom.png',
              width: size.width * 0.3,
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
