import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:radio_app/Components/card.dart';
import 'package:radio_app/Models/message.dart';
import 'package:radio_app/Widgets/constants.dart';
import 'package:share/share.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

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
        setState(() => duration = audioPlayer.duration);
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
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
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
    final file = new File('${dir.path}/audio.mp3');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Player",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          Align(
            child: _buildBackgroundBox(),
            alignment: Alignment.center,
          ),
          Align(
            child: _buildMusicUI(),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBox() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: kYellow,
            height: 200,
          ),
        ),
        Expanded(
          child: Container(
            color: kBlue,
            height: 200,
          ),
        ),
      ],
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
              _buildSongInfo(),
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

  Widget _buildSongInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: 200,
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
                  "Author",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.data.author,
                  style: TextStyle(
                    fontSize: 16,
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
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CurvedCard(
          bottomLeft: 24,
          topRight: 24,
          color: kRed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.data.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () async {
                    // Fire API to download message to device
                    id = widget.data.id.toString();
                    downloadUrl = downloadUrl + id;

                    var response = await dio.get(downloadUrl);
                    print(response);
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildSongProgress() {
    // print('=== Slider value: ${position} ===');
    // print('=== Slider Duration value: ${duration} ===');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Text("${positionText ?? ''}"),
          Expanded(
            child: duration == null
                ? Container()
                : Slider(
                    value: position?.inMilliseconds?.toDouble() ?? 0.0,
                    onChanged: (double value) {
                      print(value);

                      audioPlayer.seek((value / 1000).roundToDouble());
                    },
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                  ),
          ),
          Text("${durationText ?? ''}"),
        ],
      ),
    );
  }

  Widget _buildMusicController() {
    return CurvedCard(
      color: kGrey,
      topLeft: 24,
      bottomRight: 24,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: favColor,
                ),
                onPressed: () {
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
            IconButton(icon: Icon(Icons.skip_previous), onPressed: null),
            CurvedCard(
              child: IconButton(
                  icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  onPressed: () {
                    isPlaying ? pause() : play();
                  }),
              color: Color(0xff302931),
              topLeft: 12,
              bottomRight: 12,
            ),
            IconButton(icon: Icon(Icons.skip_next), onPressed: null),
            IconButton(
                icon: Icon(Icons.share),
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
}
