import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:radio_app/Components/card.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';
// import 'package:radio_app/Widgets/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share/share.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class Play extends StatefulWidget {
  final Data data;
  Play(this.data, {Key key}) : super(key: key);
  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  Duration duration;
  Duration position;
  Dio dio = Dio();
  String downloadUrl = "https://radioapp.herokuapp.com/api/messages/download/";
  String id = '';
  Color favColor = Colors.white;
  AudioPlayer audioPlayer;
  String kUrl = "";
  ApiController _apiController = ApiController();

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    kUrl = widget.data.message;
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        audioPlayer.onDurationChanged
            .listen((d) => setState(() => duration = d));
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(kUrl);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future _playLocal() async {
    await audioPlayer.play(localFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    if (muted) {
      await audioPlayer.setVolume(0.0);
      setState(() {
        isMuted = muted;
      });
    } else {
      await audioPlayer.setVolume(0.8);
      setState(() {
        isMuted = false;
      });
    }
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  Future _loadFile() async {
    final bytes = await _loadFileBytes(kUrl,
        onError: (Exception exception) =>
            print('_loadFile => exception $exception'));

    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/${widget.data.title}.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists())
      setState(() {
        localFilePath = file.path;
      });
  }

  // Show Snackbar
  showInfo(String note) {
    return _globalKey.currentState.showSnackBar(SnackBar(content: Text(note)));
  }

  // Add to favorites
  Future<void> storeFavorites(List<String> id) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('favorites', id);
  }

  // Button payload to add each message to string
  Future addToFavorites(int id) async {
    // Convert all ids to string first
    String _id = id.toString();
    // Add to favorites list
    List<String> favorites = List();
    favorites.add(_id);
    try {
      // setFavorite state
      await _apiController.setFavoriteMessagesState(true);
      // Persist on storage
      await storeFavorites(favorites);
      print('Added to favorites');
    } catch (e) {
      // Print error for now
      print(e.toString());
    }
  }

  // Button payload to remove message from favorites
  Future removeFromFavorites(int id) async {
    String _id = id.toString();
    // Add to favorites list
    List<String> favorites = List();
    favorites.remove(_id);
    try {
      // Persist on storage
      await storeFavorites(favorites);
      print('Removed from favorites');
    } catch (e) {
      // Print error for now
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('player'),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text('Now Playing')),
        backgroundColor: Colors.transparent,
        // Theme.of(context).primaryColor,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            blurWidget(widget.data),
            blurFilter(),
            Center(child: _buildMusicUI()),
          ],
        ),
      ),
    );
  }

  // Widget _buildBackgroundBox() {
  //   return Container();
  // }

  Widget blurWidget(Data data) {
    var f = data.picture == null
        ? null
        : new NetworkImage(data.picture, scale: 1.0);
    return new Hero(
      tag: data.author,
      child: new Container(
        child: f != null
            // ignore: conflicting_dart_import
            ? new Image(
                image: f,
                fit: BoxFit.cover,
                color: Colors.black54,
                colorBlendMode: BlendMode.darken,
              )
            : new Image(
                image: new AssetImage("assets/background1.jpeg"),
                color: Colors.black54,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
              ),
      ),
    );
  }

  Widget blurFilter() {
    return new BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: new Container(
        decoration: new BoxDecoration(color: Colors.black87.withOpacity(0.1)),
      ),
    );
  }

  Widget _buildMusicUI() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: _buildSongInfo(widget.data)),
              _buildArtistCoverPic(),
              _buildSongNameCard(),
              _buildSongProgress(),
              _buildMusicController(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSongInfo(Data data) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.data.author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            RatingBar(
              itemSize: 20,
              glowColor: Colors.white,
              allowHalfRating: true,
              unratedColor: Colors.grey,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
              ),
              initialRating: 0.0,
              direction: Axis.horizontal,
              onRatingUpdate: (d) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistCoverPic() {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      child: Image.network(
        widget.data.picture,
        height: 250,
        width: 100,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildSongNameCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.favorite, color: favColor),
                onPressed: () {
                  // Real action
                  favColor == Colors.white
                      ? addToFavorites(widget.data.id)
                      : removeFromFavorites(widget.data.id);

                  // Change color of favorite icon
                  setState(() {
                    favColor = favColor == Colors.white
                        ? Colors.redAccent
                        : Colors.white;
                    // Add particular message to favorites
                    if (favColor == Colors.redAccent)
                      showInfo('Message Added to Favorites');
                    else
                      showInfo('Message removed from Favorites');
                  });
                }),
            IconButton(
              icon: Icon(
                Icons.file_download,
                color: Colors.white,
              ),
              onPressed: () async {
                // Fire API to download message to device
                // id = widget.data.id.toString();
                // downloadUrl = downloadUrl + id;

                // var response = await dio.get(downloadUrl);
                // print(response);
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  // _audioPlayerStateSubscription.resume();
                  String message = 'Listen to the Latest message titled: ' +
                      widget.data.title +
                      ' by ' +
                      widget.data.author +
                      ' using the link provided below.\n' +
                      widget.data.message;
                  Share.share(message);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildSongProgress() {
    // print('=== Slider value: ${position} ===');
    // print('=== Slider Duration value: ${duration} ===');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: <Widget>[
          Text("${positionText ?? ''}", style: TextStyle(color: Colors.white)),
          Expanded(
            child: duration == null
                ? Container()
                : Slider(
                    value: position?.inMilliseconds?.toDouble() ?? 0.0,
                    onChanged: (double value) {
                      print(value);

                      audioPlayer.seek(Duration(
                          milliseconds:
                              duration.inMilliseconds + value.toInt()));
                    },
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                  ),
          ),
          Text("${durationText ?? ''}",
              style: TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildMusicController() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  // foregroundColor: Colors.white,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 2.0, color: Colors.white),
                        shape: BoxShape.circle),
                    child: Icon(Icons.stop, color: Colors.white),
                  )),
              onTap: () {
                // print('Mute clicked');
                stop();
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: isPlaying
                    ? Container(
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                          size: 45,
                        ),
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle))
                    : Container(
                        child: Icon(
                          Icons.play_arrow,
                          size: 45,
                          color: Colors.white,
                        ),
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle)),
              ),
              onTap: () {
                isPlaying ? pause() : play();
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                child: Container(
                    child: isMuted
                        ? Icon(Icons.volume_off, color: Colors.white)
                        : Icon(Icons.volume_up, color: Colors.white),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 2.0, color: Colors.white),
                        shape: BoxShape.circle)),
              ),
              onTap: () {
                isMuted ? mute(false) : mute(true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
