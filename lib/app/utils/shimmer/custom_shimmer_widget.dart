import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerWidget extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final bool enabled;
  const CustomShimmerWidget(
      {@required this.child,
      this.baseColor = const Color(0xff1E1E1E),
      this.highlightColor = const Color(0xff757575),
      this.enabled = true});

  @override
  _CustomShimmerWidgetState createState() => _CustomShimmerWidgetState();
}

class _CustomShimmerWidgetState extends State<CustomShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: widget.baseColor,
      highlightColor: widget.highlightColor,
      enabled: widget.enabled,
      child: widget.child,
      period: Duration(milliseconds: 800),
    );
  }
}
