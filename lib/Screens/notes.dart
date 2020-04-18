import 'package:flutter/material.dart';
import 'package:radio_app/Screens/coming.dart';

class Notes extends StatefulWidget {
  static const routeName = '/notes';
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notes'),
        backgroundColor: Colors.green,
      ),
      body: ComingSoon(),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.green,
        onPressed: () {},
      ),
    );
  }
}
