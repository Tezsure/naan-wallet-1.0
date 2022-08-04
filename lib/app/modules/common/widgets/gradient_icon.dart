import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  GradientIcon({this.child});

  final Widget child;

  final Gradient gradient = LinearGradient(colors: [
    Color(0xffE0C3FC),
    Color(0xff8EC5FC),
  ]);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient
          .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }
}
