import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gif/flutter_gif.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key? key}) : super(key: key);
  static const routeName = "/first-screen";

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  late FlutterGifController _controller;

  AudioPlayer player = AudioPlayer();

  Future<void> playAudio() async {
    String audioasset = "assets/sample_audio.mp3";
    ByteData bytes = await rootBundle.load(audioasset);
    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await player.playBytes(soundbytes);
    if (result == 1) {
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  playGuitar() {
    _controller.repeat(min: 0, max: 10, period: Duration(milliseconds: 3000));
  }

  @override
  void initState() {
    super.initState();
    _controller = FlutterGifController(vsync: this);
    playAudio();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First screen"),
      ),
      body: Container(
        child: Column(
          children: [
            Image.asset("assets/music_guitar.gif"),
          ],
        ),
      ),
    );
  }
}
