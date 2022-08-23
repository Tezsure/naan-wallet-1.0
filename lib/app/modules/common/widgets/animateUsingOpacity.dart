import 'package:flutter/material.dart';

class AnimateUsingOpacity extends StatefulWidget {
  final double opacity;
  final Duration duration;
  final Widget child;
  const AnimateUsingOpacity(this.opacity, this.duration,
      {@required this.child});

  @override
  _AnimateUsingOpacityState createState() => _AnimateUsingOpacityState();
}

class _AnimateUsingOpacityState extends State<AnimateUsingOpacity> {
  bool showChild;
  @override
  void initState() {
    super.initState();
    showChild = true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: widget.duration,
      onEnd: () {
        setState(() {
          showChild = false;
        });
      },
      child: showChild
          ? Container(
              child: widget.child,
            )
          : SizedBox(),
    );
  }
}
