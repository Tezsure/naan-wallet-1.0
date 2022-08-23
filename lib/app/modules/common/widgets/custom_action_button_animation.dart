import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAnimatedActionButton extends StatefulWidget {
  final String text;
  final bool isFilled;
  final Function onTap;
  final double width;
  final double height;
  final Color backgroudColor;
  final double fontSize;
  CustomAnimatedActionButton(this.text, this.isFilled, this.onTap,
      {this.width, this.height, this.backgroudColor, this.fontSize});

  @override
  _CustomAnimatedActionButtonState createState() =>
      _CustomAnimatedActionButtonState();
}

class _CustomAnimatedActionButtonState extends State<CustomAnimatedActionButton>
    with SingleTickerProviderStateMixin {
  double dynamicHeight;
  double dynamicWidth;
  Color dynamicColor;

  @override
  void initState() {
    super.initState();
    dynamicHeight = widget.height ?? 40;
    dynamicWidth = widget.width ?? Get.width * 0.9;
    dynamicColor = Color(0xff7088C7);
  }

  squeezeAnimation() async {
    dynamicHeight = dynamicHeight - 2;
    dynamicWidth = dynamicWidth - 2;
    dynamicColor = dynamicColor.withOpacity(0.6);
    await Future.delayed(Duration(milliseconds: 0), () {
      setState(() {});
    });
    await Future.delayed(Duration(milliseconds: 100));
    dynamicHeight = dynamicHeight + 2;
    dynamicWidth = dynamicWidth + 2;
    dynamicColor = Color(0xff7088C7);
    setState(() {});
  }

  zoomIn() {
    dynamicHeight = dynamicHeight - 4;
    dynamicWidth = dynamicWidth - 4;
    dynamicColor = dynamicColor.withOpacity(0.6);
    setState(() {});
  }

  zoomOut() {
    dynamicHeight = dynamicHeight + 4;
    dynamicWidth = dynamicWidth + 4;
    dynamicColor = Color(0xff7088C7);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        zoomIn();
      },
      onLongPressUp: () {
        zoomOut();
      },
      onTap: () async {
        await squeezeAnimation();
        widget.onTap();
      },
      child: Container(
        height: widget.height ?? 40,
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: dynamicHeight,
            width: dynamicWidth,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: dynamicColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isFilled
                    ? dynamicColor
                    : widget.backgroudColor ?? Color(0xff1e1e1e),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.fontSize ?? 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
