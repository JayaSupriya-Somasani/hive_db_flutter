
import 'package:flutter/material.dart';

class MixedAnimation extends StatefulWidget {
  const MixedAnimation({Key? key}) : super(key: key);

  @override
  State<MixedAnimation> createState() => _MixedAnimationState();
}

class _MixedAnimationState extends State<MixedAnimation>
    with TickerProviderStateMixin {
  bool isBouncing = true;
  int bounceCount = 0;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _ballFillController;
  late Animation<double> _ballFillAnimation;

  @override
  void initState() {
    super.initState();
    bouncingBall();
    _ballFillController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _ballFillAnimation =
        Tween<double>(begin: 0, end: 1).animate(_ballFillController);
  }

  bouncingBall() {
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 10,
      upperBound: 100,
    );

    _bounceAnimation = Tween(begin: 0.0, end: 100.0).animate(_bounceController);

    _bounceController.addListener(() {
      setState(() {});
    });

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bounceCount++;
        if (bounceCount >= 2) {
          _bounceController.stop();
          isBouncing = false;
          fullScreenBall();
        } else {
          _bounceController.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        _bounceController.forward();
      }
    });
    _bounceController.forward();
  }

  fullScreenBall() {
    _ballFillAnimation.addListener(() {
      setState(() {});
    });
    _ballFillController.forward();
    _ballFillController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _ballFillController.dispose();
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mixed Animation"),
        ),
        body: Builder(
            builder: (context) => isBouncing
                ? Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 30),
                    child: Container(
                        margin:
                            EdgeInsets.only(top: _bounceController.value * 3),
                        height: 40,
                        width: 60,
                        decoration: const BoxDecoration(
                            color: Colors.indigo, shape: BoxShape.circle)))
                : Center(
                    child: Container(
                      height: screenHeight * _ballFillAnimation.value,
                      width: screenWidth * _ballFillAnimation.value,
                      decoration: BoxDecoration(
                          shape: _ballFillAnimation.value == 1.0
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          color: Colors.indigo),
                    ),
                  )
        )
    );
  }
}
