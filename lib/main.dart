import 'package:flutter/material.dart';
import 'package:radio_app/home.dart';
import 'package:radio_app/podcasts.dart';
import 'login.dart';
import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        // theme: ThemeData.dark().copyWith(primaryColor: kPrimaryColor),
        theme: ThemeData(
            hintColor: Color(0xFF371AD8),
            primaryColor: Color(0xFF4868D8),
            fontFamily: "Montserrat",
            canvasColor: Colors.transparent),
        home: Login());
  }
}
