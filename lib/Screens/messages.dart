import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';
import 'package:radio_app/Screens/messageDetail.dart';
import 'package:radio_app/bloc/messagebloc_bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class Messages extends StatefulWidget {
  static const routeName = '/messages';
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessageblocBloc messageblocBloc;
  // ReloadmessageBloc reloadmessageBloc;
  ApiController _apiController = ApiController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    messageblocBloc = BlocProvider.of<MessageblocBloc>(context);
    messageblocBloc.add(FetchMessagesEvent());
  }

  // Function to all fetchMessagesfromAPi
  Future<void> requestMessageFetch() async {
    await _apiController.fetchMessages();
    await Future.delayed(Duration(seconds: 3));
    _refreshController.refreshCompleted();
  }

  runMessageFetch() {
    requestMessageFetch();
    setState(() {});
    print('Message fetch in background complete');
    // _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: BlocListener<MessageblocBloc, MessageblocState>(
        listener: (context, state) {
          if (state is MessageblocErrorState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<MessageblocBloc, MessageblocState>(
          builder: (context, state) {
            if (state is MessageblocInitialState) {
              return isLoading();
            } else if (state is MessageblocLoadingState) {
              return isLoading();
            } else if (state is MessageblocLoadedState) {
              return buildMessage(state.messages);
            } else if (state is MessageblocErrorState) {
              return hasError(state.message);
            } else {
              return Center(child: Text('Unknown Error'));
            }
          },
        ),
      ),
    );
  }

  Widget buildMessage(List<Data> messages) {
    return SmartRefresher(
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: runMessageFetch,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          // var message = messages.data[index];
          return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                  decoration:
                      // Color.fromRGBO(64, 75, 96, .9)
                      BoxDecoration(color: Colors.white),
                  child: listTile(messages[index])));
        },
      ),
    );
  }

  Widget listTile(Data data) {
    // print(data.picture);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.black26))),
        child: Icon(Icons.message, color: Colors.black54),
      ),
      title: Text(
        data.title,
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.border_color,
            color: Colors.black54,
            size: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(data.author, style: TextStyle(color: Colors.black)),
          )
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
        onPressed: () {},
      ),
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => MessageDetail(data)));

        Navigator.of(context).push(new PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
            return MessageDetail(data);
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
    );
  }

  Widget isLoading() {
    return Container(
        child: Center(
            child: Theme(
      data: Theme.of(context).copyWith(accentColor: Color(0xFF17ead9)),
      child: CircularProgressIndicator(
        strokeWidth: 5.0,
      ),
    )));
  }

  Widget hasError(String message) {
    return Center(child: Text(message));
  }
}
