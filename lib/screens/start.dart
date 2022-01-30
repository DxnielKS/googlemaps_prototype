import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:googlemaps_prototype/screens/login_signup_buttons.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 100,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/map1.png'),
            height: 200,
          ),
          SizedBox(height: 10,),
          Container(
            child: Column(
              children: [
                AuthButton(color: Colors.green, text: "LOG IN", onPress: (){
                }),
                AuthButton(color: Colors.blue, text: "SIGN UP", onPress: (){
                }),

              ],
            ),
          )
        ],
      ),
    );
  }
}
