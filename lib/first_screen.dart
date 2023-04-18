import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirstScreen extends StatefulWidget {
   FirstScreen({Key? key}) : super(key: key);
  static const routeName = "/first-screen";

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {

  AudioPlayer player = AudioPlayer();

  Future<void> playAudio() async {
    String audioasset = "assets/sample_audio.mp3";
    ByteData bytes = await rootBundle.load(audioasset);
    Uint8List soundbytes = bytes.buffer
        .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await player.playBytes(soundbytes);
    if (result == 1) {
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  @override
  void initState(){
    super.initState();
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
        child: const Text("This is first screen"),
      ),
    );
  }
}
