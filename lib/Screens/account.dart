import 'package:flutter/material.dart';
import 'package:radio_app/Screens/coming.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Account'),
        backgroundColor: Colors.green,
      ),
      body: ComingSoon(),
    );
  }
}
