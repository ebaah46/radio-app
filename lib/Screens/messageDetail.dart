import 'package:flutter/material.dart';
import 'package:radio_app/Components/button.dart';
import 'package:radio_app/Models/message.dart';
import 'package:radio_app/Screens/play.dart';

class MessageDetail extends StatefulWidget {
  final Data data;
  MessageDetail(this.data, {Key key}) : super(key: key);
  @override
  _MessageDetailState createState() => _MessageDetailState();

  var likeIcon = Icons.favorite_border;
}

class _MessageDetailState extends State<MessageDetail> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        Text(
          widget.data.title,
          softWrap: true,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        Container(
          width: 190.0,
          child: new Divider(color: Colors.white),
        ),
        SizedBox(height: 5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.only(left: 3.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'by',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        Text(
                          widget.data.author,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ))),
            // Expanded(flex: 1, child: likeMessage())
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          // padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          // decoration: new BoxDecoration(
          //   image: new DecorationImage(
          //     image: new NetworkImage(widget.data.picture),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: FadeInImage.assetNetwork(
            fadeInDuration: Duration(milliseconds: 1000),
            // fadeOutDuration: Duration(milliseconds: 1000),
            fadeInCurve: Curves.bounceInOut,
            // fadeOutCurve: Curves.bounceOut,
            placeholder: 'assets/images/loading_bar.gif',
            placeholderCacheHeight: 50,
            placeholderCacheWidth: 50,
            placeholderScale: 10.1,
            image: widget.data.picture,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white38),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 50.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Text(
          widget.data.description,
          style: TextStyle(fontSize: 15.0, wordSpacing: 1.0),
        ));
    final readButton = FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          child: CustomButton('Play Audio Message'),
          onTap: () {
            Navigator.of(context).push(new PageRouteBuilder(
              pageBuilder: (BuildContext context, _, __) {
                return Play(widget.data);
              },
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) =>
                  Align(
                child: SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
              ),
            ));
          },
        ),
      ),
    );
    final bottomContent = Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: bottomContentText),
          readButton,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      key: _globalKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: topContent),
          Expanded(child: bottomContent)
        ],
      ),
    );
  }
}
