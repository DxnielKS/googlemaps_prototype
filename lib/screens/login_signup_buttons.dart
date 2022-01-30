import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  // paramters which this function needs
  final Color color;
  final String text;
  final Function onPress;

  AuthButton({
    required this.color,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: double.infinity,
        color: color,
        child: ButtonTheme(
            child: TextButton(
              onPressed: () {print("hello");},
              style: TextButton.styleFrom(
                primary: color
              ),
              child :Text(text,style:
              TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              ),
            ),
          ),
        );
  }
}