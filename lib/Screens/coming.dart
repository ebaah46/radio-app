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
          Container(
              height: 150.0,
              width: 150.0,
              constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
              child: FittedBox(
                child: Image.asset(
                  'assets/images/soon.jpg',
                  fit: BoxFit.cover,
                  // height: 200,
                  // width: 200,
                ),
              )),
          Container(
              child: Column(
            children: <Widget>[
              Center(
                  child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Hold On!!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'This feature is still under development.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              )),
            ],
          ))
        ],
      ),
    );
  }
}
