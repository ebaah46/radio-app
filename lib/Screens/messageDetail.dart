import 'package:flutter/material.dart';
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
    showInfo(String note) {
      return _globalKey.currentState
          .showSnackBar(SnackBar(content: Text(note)));
    }

    void changeIconDetails() {
      if (widget.likeIcon == Icons.favorite_border) {
        setState(() {
          widget.likeIcon = Icons.favorite;
        });
        showInfo('Added to favorites');
      } else {
        widget.likeIcon = Icons.favorite_border;
        showInfo('Removed from favorites');
      }
    }

    Widget likeMessage() {
      return Container(
        child: IconButton(
            icon: Icon(widget.likeIcon),
            onPressed: () {
              // Change icon to filled Icon
              changeIconDetails();
            }),
      );
    }

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 70.0),
        Icon(
          Icons.description,
          color: Colors.white,
          size: 30.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          widget.data.title,
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.border_color,
                  color: Colors.white,
                )),
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.data.author,
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: likeMessage())
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(widget.data.picture),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      widget.data.description,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Play(widget.data)))
          },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
              Text("PLAY FULL MESSAGE", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );

    return Scaffold(
      key: _globalKey,
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
