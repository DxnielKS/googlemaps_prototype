import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        body: Center(
          child: SpinKitFadingGrid(
            color: Colors.green,
            size: 80,
          ),
        )
    );
  }
}