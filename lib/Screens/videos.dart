import 'package:flutter/material.dart';

import 'coming.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Videos'),
        backgroundColor: Colors.green,
      ),
      body: ComingSoon(),
    );
  }
}
