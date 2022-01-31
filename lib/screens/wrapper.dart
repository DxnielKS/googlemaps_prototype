import 'package:flutter/material.dart';
import 'package:googlemaps_prototype/model/customer.dart';
import 'package:googlemaps_prototype/screens/home/home.dart';
import 'package:googlemaps_prototype/screens/start.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Customer?>(context);
    if (user == null) {
      return StartPage();
    } else {
      return MyApp();
    }
  }
}
