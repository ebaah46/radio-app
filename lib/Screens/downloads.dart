import 'package:flutter/material.dart';
import 'package:radio_app/Screens/coming.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            title: Text('Downloads'),
            backgroundColor: Colors.green),
        body: ComingSoon());
  }
}
