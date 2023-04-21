
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);
  static const routeName = "/second-screen";

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playSound() async {
    String audiopath = "assets/cat.mp3";
    ByteData byte = await rootBundle.load(audiopath);
    Uint8List soundPlay = byte.buffer.asUint8List(
        byte.offsetInBytes, byte.lengthInBytes);
    await audioPlayer.playBytes(soundPlay);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSound();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second screen"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Image.network(
                 "https://global.discourse-cdn.com/twitter/original/2X/1/1f8d67fe1366937e20970fbcc4c374f366447819.gif",
              loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
