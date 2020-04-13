import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Screens/messages.dart';
import 'package:radio_app/Screens/podcasts.dart';
import 'package:radio_app/bloc/messagebloc_bloc.dart';
import 'package:radio_app/live.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget title;

  final _widgetOption = [
    Text("Live"),
    Text("Messages"),
    Text("Alert"),
    Text("About")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  elevation: 0.1,
                  title: Text('EWAK Radio Ministry'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(icon: Icon(Icons.radio)),
                      Tab(icon: Icon(Icons.headset)),
                      Tab(icon: Icon(Icons.favorite))
                    ],
                  )),
              body: TabBarView(children: [
                Text('Nothing'),
                BlocProvider(
                    create: (BuildContext context) =>
                        MessageblocBloc(apiController: ApiController()),
                    child: Messages()),
                Container()
              ]),
            )));
  }

  Widget _buildChild() {
    if (_widgetOption.elementAt(_selectedIndex) == _widgetOption.elementAt(0)) {
      return Live();
    } else if (_widgetOption.elementAt(_selectedIndex) ==
        _widgetOption.elementAt(1)) {
      return Podcasts();
    } else if (_widgetOption.elementAt(_selectedIndex) ==
        _widgetOption.elementAt(2)) {
      return Container();
    } else {
      return Container();
    }
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      title = _widgetOption[value];
    });
  }
}
