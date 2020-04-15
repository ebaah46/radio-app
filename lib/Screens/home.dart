import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Screens/coming.dart';
import 'package:radio_app/Screens/favorites.dart';
import 'package:radio_app/Screens/messages.dart';
import 'package:radio_app/Screens/podcasts.dart';
import 'package:radio_app/bloc/favorites_bloc.dart';
import 'package:radio_app/bloc/messagebloc_bloc.dart';
import 'package:radio_app/live.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _selectedIndex = 0;
  // Widget title;

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  // final _widgetOption = [
  //   Text("Live"),
  //   Text("Messages"),
  //   Text("Alert"),
  //   Text("About")
  // ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          body: DefaultTabController(
              initialIndex: 1,
              length: 3,
              child: Scaffold(
                drawer: Drawer(),
                backgroundColor: Colors.white,
                appBar: AppBar(
                    // leading: IconButton(
                    //     icon: Icon(Icons.menu, color: Colors.white),
                    //     onPressed: null),
                    backgroundColor: Colors.green,
                    centerTitle: true,
                    elevation: 0.1,
                    title: Text('EWAK Radio'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Logout User
                          _onBackPressed();
                        },
                      )
                    ],
                    bottom: TabBar(
                      tabs: <Widget>[
                        Tab(icon: Icon(Icons.radio)),
                        Tab(icon: Icon(Icons.headset)),
                        Tab(icon: Icon(Icons.favorite))
                      ],
                    )),
                body: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Image.network(
                              "https://raw.githubusercontent.com/vcardona/Flutter-Login-Page-UI-Explained/master/assets/image_02.png"),
                        ),
                        Expanded(
                          child: Image.network(
                              "https://raw.githubusercontent.com/vcardona/Flutter-Login-Page-UI-Explained/master/assets/image_02.png"),
                        )
                      ],
                    ),
                    TabBarView(children: [
                      ComingSoon(),
                      BlocProvider(
                          create: (BuildContext context) =>
                              MessageblocBloc(apiController: ApiController()),
                          child: Messages()),
                      BlocProvider(
                          create: (BuildContext context) =>
                              FavoritesBloc(apiController: ApiController()),
                          child: Favorites())
                    ]),
                  ],
                ),
              ))),
    );
  }

  // Widget _buildChild() {
  //   if (_widgetOption.elementAt(_selectedIndex) == _widgetOption.elementAt(0)) {
  //     return Live();
  //   } else if (_widgetOption.elementAt(_selectedIndex) ==
  //       _widgetOption.elementAt(1)) {
  //     return Podcasts();
  //   } else if (_widgetOption.elementAt(_selectedIndex) ==
  //       _widgetOption.elementAt(2)) {
  //     return Container();
  //   } else {
  //     return Container();
  //   }
  // }

  // void _onItemTapped(int value) {
  //   setState(() {
  //     _selectedIndex = value;
  //     title = _widgetOption[value];
  //   });
  // }
}
