import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:isolate/isolate_runner.dart';
import 'dart:convert';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:radio_app/message.dart';
import 'package:radio_app/messageDetail.dart';
// import 'package:http/http.dart' as http;

Dio dio = new Dio();
// Fetch messages from API
Future<List<Data>> fetchMessages([howMany = 5]) async {
  Response response = await dio.get(
    'https://radio-api.herokuapp.com/api/messages/index',
  );

  if (response.statusCode == 200) {
    String messageString = jsonEncode(response.data);
    Map messageMap = json.decode(messageString);

    var message = Message.fromJson(messageMap);
    for (var details in message.data) {}

    return message.data;

    // print()
  } else {
    throw Exception('Failed to load messages');
  }
  // print(response);
}

// Fetch Messages in background

Future<List<Data>> fetchMessageInBackground(int count) async {
  final runner = await IsolateRunner.spawn();
  return runner.run(fetchMessages, count).whenComplete(() => runner.close());
}

// Load Messages into stream
loadMessages() async {
  fetchMessages().then((res) async {
    return res;
  });
}

class Podcasts extends StatefulWidget {
  Podcasts({Key key}) : super(key: key);

  @override
  _PodcastsState createState() => _PodcastsState();
}

class _PodcastsState extends State<Podcasts> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

// Show Snackbar
  showInfo(String note) {
    return _globalKey.currentState.showSnackBar(SnackBar(content: Text(note)));
  }

  // refresh handling function
  Future<Null> _handleRefresh() async {
    fetchMessageInBackground(5).then((res) async {
      showInfo('Messages loaded successfully');
      return null;
    });
  }

  @override
  void initState() {
    loadMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: FutureBuilder<List<Data>>(
          // stream: _streamController.stream,
          future: fetchMessageInBackground(10),
          builder: (context, snapshot) {
            print('Has error: ${snapshot.hasError}');
            print('Has data: ${snapshot.hasData}');
            print('Snapshot Data ${snapshot.data}');
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Scrollbar(
                        child: LiquidPullToRefresh(
                          onRefresh: _handleRefresh,
                          height: 80.0,
                          color: Colors.blueAccent,
                          backgroundColor: Colors.blueGrey[800],
                          showChildOpacityTransition: false,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              var message = snapshot.data[index];

                              return Card(
                                  elevation: 8.0,
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(64, 75, 96, .9)),
                                      child: listTile(message)));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error Retrieving data from Server'));
            }
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }),
    );
  }

  Widget listTile(Data data) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Colors.white),
        ),
        title: Text(
          data.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Icon(
              Icons.border_color,
              color: Colors.yellowAccent,
              size: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(data.author, style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        trailing: IconButton(
          icon:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MessageDetail(data)));
          },
        ));
  }
}
