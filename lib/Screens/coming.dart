import 'package:flutter/material.dart';
// import 'package:flutter_emoji/flutter_emoji.dart';

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var parser = EmojiParser();

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
              flex: 2,
              child: Image.asset(
                'assets/images/soon.jpg',
                fit: BoxFit.fitWidth,
              )),
          Expanded(
              child: Center(
                  child: Text(
            'This feature is still under development',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          )))
        ],
      ),
    );
  }
}
