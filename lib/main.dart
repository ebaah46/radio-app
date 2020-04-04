import 'package:flutter/material.dart';
import 'package:radio_app/home.dart';
import 'package:radio_app/podcasts.dart';

import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        theme: ThemeData.dark().copyWith(primaryColor: kPrimaryColor),
        home: HomePage());
  }
}
