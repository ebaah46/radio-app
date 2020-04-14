import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:radio_app/Components/button.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';
import 'package:radio_app/Screens/play.dart';
import 'package:radio_app/bloc/favorites_bloc.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  FavoritesBloc _favoritesBloc;
  ApiController _apiController = ApiController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _isReloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _favoritesBloc = BlocProvider.of<FavoritesBloc>(context);
    _favoritesBloc.add(LoadFavoriteMessages());
  }

  Future<void> reload() async {
    await Future.delayed(Duration(seconds: 3));
    _refreshController.refreshCompleted();
    setState(() {
      _isReloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          BlocBuilder<FavoritesBloc, FavoritesState>(builder: (context, state) {
        if (state is FavoritesInitial) {
          return buildLoading();
        } else if (state is FavoritesLoading) {
          return buildLoading();
        } else if (state is FavoritesLoaded) {
          return buildMessages(state.messages);
        } else if (state is FavoritesEmpty) {
          return buildError('Test');
          // buildEmpty();
        } else if (state is FavoritesError) {
          return buildError(state.error);
        }
      }),
    );
  }

  Widget buildLoading() {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildMessages(List<Data> messages) {
    return SmartRefresher(
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: reload,
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
        child: Icon(Icons.favorite_border, color: Colors.black54),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Play(data)));
      },
    );
  }

  Widget buildEmpty() {
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
              constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
              child: FittedBox(
                child: Image.asset(
                  'assets/images/sad.png',
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sorry!!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              Center(
                  child: Text(
                'No favorites added yet.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              )),
            ],
          ))
        ],
      ),
    );
  }

  Widget buildError(String error) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Container(
              // flex: 2,
              constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
              child: FittedBox(
                child: Image.asset(
                  'assets/images/suprise.png',
                  fit: BoxFit.fitWidth,
                  // height: 200,
                  // width: 200,
                ),
              )),
          Container(
              child: Column(
            children: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sorry!!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Failed to load favorite messages.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              )),
            ],
          )),
          InkWell(
            child: _isReloading
                ? Center(child: CircularProgressIndicator())
                : CustomButton('Retry'),
            onTap: () {
              // Refresh Page
              _isReloading = true;
              reload();
            },
          )
        ],
      ),
    );
  }
}
