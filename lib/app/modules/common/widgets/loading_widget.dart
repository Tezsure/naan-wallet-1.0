import 'package:flutter/material.dart';
import 'dart:math' as math;


// ignore: must_be_immutable
class LoaderWidget extends StatefulWidget {
  var width;
  var height;
  LoaderWidget({this.width, this.height});

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Image.asset(
        'assets/login/loader.png',
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
