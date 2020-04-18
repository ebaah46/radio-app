import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:share/share.dart';

import 'dart:async';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class Play extends StatefulWidget {
  final Data data;
  Play(this.data, {Key key}) : super(key: key);
  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  Dio dio = Dio();
  String downloadUrl = "https://radioapp.herokuapp.com/api/messages/download/";
  String id = '';
  Color favColor = Colors.white;

  // String kUrl = "";
  ApiController _apiController = ApiController();

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  String url;
  PlayerMode mode = PlayerMode.MEDIA_PLAYER;

  bool isMuted = false;
  bool isDownloaded = false;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRouteState.earpiece;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    url = widget.data.message;
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  Future mute(bool muted) async {
    if (muted) {
      await _audioPlayer.setVolume(0.0);
      setState(() {
        isMuted = muted;
      });
    } else {
      await _audioPlayer.setVolume(0.8);
      setState(() {
        isMuted = false;
      });
    }
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
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
    final bytes = await readBytes(url);
    final dir = await getApplicationDocumentsDirectory();
    String title = widget.data.title.trim();
    final file = File('${dir.path}/$title.mp3');
    print('Starting download');
    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      print('Done downloading');
      showInfo('Message, ${widget.data.title} downloaded');
      setState(() {
        localFilePath = file.path;
      });
      // showInfo('Message ${widget.data.title} downloaded');
    }
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // physics: BouncingScrollPhysics(),
        children: <Widget>[
          Expanded(
              flex: 2, child: Center(child: _buildMessageInfo(widget.data))),
          Expanded(flex: 6, child: _buildAuthorCoverPic()),
          Expanded(flex: 1, child: _buildMessageControl()),
          Expanded(flex: 1, child: _buildMessageProgress()),
          Expanded(flex: 2, child: _buildPlayerController())
        ],
      ),
    );
  }

  Widget _buildMessageInfo(Data data) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    height: 3,
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
            ),
            RatingBar(
              itemSize: 20,
              glowColor: Colors.red[400],
              allowHalfRating: true,
              unratedColor: Colors.white,
              itemCount: 5,
              glowRadius: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
              ),
              initialRating: 0.0,
              direction: Axis.horizontal,
              onRatingUpdate: (d) {
                print('Updated $d');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorCoverPic() {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      child: Image.network(
        widget.data.picture,
        // height: 300,
        // width: 100,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildMessageControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: 200,
        height: MediaQuery.of(context).size.height * 0.18,
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
              onPressed: () {
                // Download message and save on device
                print('About to download message ${widget.data.title}');
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Download Message'),
                      content: Text(
                          'Are you sure you want to download this message?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                            showInfo('Download aborted');
                          },
                        ),
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            // deleteToken();
                            // Navigator.of(context).popUntil((route) => route.isFirst);
                            _loadFile();

                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  // _audioPlayerStateSubscription.resume();
                  print('About to share message ${widget.data.title}');
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

  Widget _buildMessageProgress() {
    return Padding(
      padding: const EdgeInsets.only(right: 2, left: 2, top: 20),
      child: Row(
        children: <Widget>[
          Text("${_positionText ?? ''}", style: TextStyle(color: Colors.white)),
          Expanded(
            child: _duration == null
                ? SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        disabledThumbColor: Theme.of(context).cardColor,
                        disabledActiveTrackColor: Theme.of(context).cardColor),
                    child: Slider(
                      // divisions: 10,
                      max: 100,
                      value: 100,
                      onChanged: null,
                    ),
                  )
                : Slider(
                    activeColor: Theme.of(context).cardColor,
                    onChanged: (v) {
                      final Position = v * _duration.inMilliseconds;
                      _audioPlayer
                          .seek(Duration(milliseconds: Position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position.inMilliseconds > 0 &&
                            _position.inMilliseconds < _duration.inMilliseconds)
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                  ),
          ),
          Text("${_durationText ?? ''}", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPlayerController() {
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
                _stop();
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: _isPlaying
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
                _isPlaying ? _pause() : _play();
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
