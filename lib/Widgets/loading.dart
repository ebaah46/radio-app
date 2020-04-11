import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                  strokeWidth: 6.0, backgroundColor: Color(0xFF17ead9)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            )
          ],
        ));
  }
}
