import 'package:flutter/material.dart';
import 'package:radio_app/Screens/coming.dart';

class Authors extends StatefulWidget {
  @override
  _AuthorsState createState() => _AuthorsState();
}

class _AuthorsState extends State<Authors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Authors'),
        backgroundColor: Colors.green,
      ),
      body: ComingSoon(),
    );
  }
}
