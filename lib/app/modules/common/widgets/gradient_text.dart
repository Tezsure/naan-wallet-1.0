import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
    @required this.textStyle,
    this.align,
  });

  final String text;
  final Gradient gradient;
  final TextStyle textStyle;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: align,
        style: textStyle,
      ),
    );
  }
}
