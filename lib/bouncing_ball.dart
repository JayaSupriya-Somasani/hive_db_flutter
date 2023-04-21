import 'dart:ffi';

import 'package:flutter/material.dart';

class BouncingBall extends StatefulWidget {
  @override
  _BouncingBallState createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  // int bounceCount=0;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 1),
  //     lowerBound: 0,
  //     upperBound: 100,
  //   );
  //
  //   _controller.addListener(() {
  //     setState(() {});
  //   });
  //   _controller.addStatusListener((status) {
  //     if(_controller==AnimationStatus.completed){
  //       bounceCount++;
  //       if(bounceCount>=3){
  //         _controller.stop();
  //       }else{
  //         _controller.reverse();
  //       }
  //     }else if(status==AnimationStatus.dismissed){
  //       _controller.forward();
  //     }
  //   });
  //   _controller.repeat(reverse: true);
  // }

  int _bounceCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 100,
    );

    _animation = Tween(begin: 0.0, end: 100.0).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceCount++;
        if (_bounceCount >= 3) {
          _controller.stop();
        } else {
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("controller value is ${_controller.value}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Bouncing ball"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
            margin: EdgeInsets.only(top: _controller.value*3 ),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo,
            ),
            width: 40.0,
            height: 60.0,
          ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
}
