import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    controller.forward();
    controller.addStatusListener((status) {
      debugPrint("Animation status ${AnimationStatus.completed==status}");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    debugPrint("screen height$screenHeight and width $screenWidth  and animation value is ${animation.value}");

    return Scaffold(
      appBar: AppBar(title: Text("Animated Screen"),),
      body: Center(
        child: Container(
          decoration:  BoxDecoration(
            shape: animation.value==1.0? BoxShape.rectangle:BoxShape.circle,
            color: Colors.deepPurpleAccent,
          ),
          height: screenHeight*animation.value,
          width: screenWidth  *animation.value,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
