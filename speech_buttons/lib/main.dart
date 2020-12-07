import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language buttons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Speech buttons'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    // create this only once
    _audioCache = AudioCache(prefix: 'assets/', fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text('Salut!'),
              onPressed: () {
                _audioCache.play('1.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Ce faci?'),
              onPressed: () {
                _audioCache.play('2.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Cum te cheama?'),
              onPressed: () {
                _audioCache.play('3.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Unde esti?'),
              onPressed: () {
                _audioCache.play('4.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Cand vii?'),
              onPressed: () {
                _audioCache.play('5.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Cum ai facut asta?'),
              onPressed: () {
                _audioCache.play('6.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Arati bine!'),
              onPressed: () {
                _audioCache.play('7.mp3');
              },
            ),
            ElevatedButton(
              child: const Text('Te respect!'),
              onPressed: () {
                _audioCache.play('8.mp3');
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}