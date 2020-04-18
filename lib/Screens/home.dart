import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Screens/account.dart';
import 'package:radio_app/Screens/authors.dart';
import 'package:radio_app/Screens/coming.dart';
import 'package:radio_app/Screens/downloads.dart';
import 'package:radio_app/Screens/favorites.dart';
import 'package:radio_app/Screens/messages.dart';
import 'package:radio_app/Screens/notes.dart';
import 'package:radio_app/Screens/settings.dart';
import 'package:radio_app/Screens/videos.dart';
import 'package:radio_app/Widgets/CustomIcons.dart';
import 'package:radio_app/bloc/favorites_bloc.dart';
import 'package:radio_app/bloc/messagebloc_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _selectedIndex = 0;
  // Widget title;
  ApiController _apiController = ApiController();
  deleteToken() async {
    print('deleting token');
    _apiController.removeToken('token');
  }

  navToWeb(String url) async {
    if (await canLaunch(url))
      await launch(url, forceWebView: true, enableJavaScript: true);
    else
      throw 'Failed to launch $url';
  }

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
                    deleteToken();
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
                drawer: drawer(),
                backgroundColor: Colors.white,
                appBar: AppBar(
                    // leading: IconButton(
                    //     icon: Icon(Icons.menu, color: Colors.white),
                    //     onPressed: null),
                    backgroundColor: Colors.green,
                    centerTitle: true,
                    elevation: 0.5,
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

// Drawer Widget

  Widget drawer() {
    return Drawer(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            _createDrawerItem(
                icon: Icons.face,
                text: 'Authors',
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Authors();
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
                }),
            // Navigator.pushReplacementNamed(context, Routes.messages)),
            _createDrawerItem(
                icon: Icons.note,
                text: 'Notes',
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Notes();
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
                }),
            _createDrawerItem(
                icon: Icons.video_library,
                text: 'Videos',
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Videos();
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
                }),
            Divider(),
            _createDrawerItem(
                icon: CustomIcons.facebook,
                text: 'Facebook',
                onTap: () {
                  navToWeb(
                      'https://www.facebook.com/EWAK-RADIO-105188807796569/');
                }),
            _createDrawerItem(
                icon: FeatherIcons.youtube,
                text: 'Youtube',
                onTap: () {
                  navToWeb(
                      'https://www.youtube.com/channel/UCZkVG0oTg5XMIjOJDVWSe5Q');
                }),
            _createDrawerItem(
                icon: Icons.file_download,
                text: 'Downloads',
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Downloads();
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
                }),
            Divider(),
            _createDrawerItem(
                icon: Icons.account_box,
                text: 'My Account',
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Account();
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
                }),
            _createDrawerItem(
                icon: Icons.settings,
                text: 'Settings',
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Settings();
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
                }),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
// Drawer widget components

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/background5.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("EWAK Radio Ministry",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
