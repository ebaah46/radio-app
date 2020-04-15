import 'package:flutter/material.dart';

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
      appBar: AppBar(centerTitle: true, title: Text('Notes')),
      body: Container(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Color(0xFF4868D8),
        onPressed: () {},
      ),
    );
  }
}
