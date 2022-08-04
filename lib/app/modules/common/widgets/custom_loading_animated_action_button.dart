import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoadingAnimatedActionButton extends StatefulWidget {
  final String text;
  final bool isFilled;
  final Function onTap;
  final double width;
  final double height;
  final Color backgroudColor;
  final double fontSize;
  final Duration loadingAnimationDuration;
  CustomLoadingAnimatedActionButton(
    this.text,
    this.isFilled,
    this.onTap, {
    this.height,
    this.width,
    this.backgroudColor,
    this.fontSize,
    this.loadingAnimationDuration,
  });

  @override
  _CustomLoadingAnimatedButtonState createState() =>
      _CustomLoadingAnimatedButtonState();
}

class _CustomLoadingAnimatedButtonState
    extends State<CustomLoadingAnimatedActionButton> {
  double dynamicHeight;
  double dynamicWidth;
  bool isProcessCompleted;
  Color dynamicColor;

  @override
  void initState() {
    super.initState();
    dynamicHeight = widget.height ?? 40;
    dynamicWidth = widget.width ?? Get.width * 0.9;
    isProcessCompleted = false;
    dynamicColor = Color(0xff7088C7);
  }

  squeezeAnimation() async {
    dynamicWidth = dynamicHeight;
    setState(() {});
    if (widget.loadingAnimationDuration != null) {
      await Future.delayed(widget.loadingAnimationDuration, () async {
        isProcessCompleted = true;
        setState(() {});
        dynamicHeight = dynamicHeight - 8;
        dynamicWidth = dynamicWidth - 8;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 100), () {
          dynamicHeight = dynamicHeight + 8;
          dynamicWidth = dynamicWidth + 8;
          setState(() {});
          Future.delayed(Duration(seconds: 2), () async {
            dynamicWidth = widget.width ?? Get.width * 0.9;
            isProcessCompleted = false;
            if (mounted) setState(() {});
          });
        });
      });
    }
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        zoomIn();
      },
      onLongPressUp: () {
        zoomOut();
      },
      onTap: () async {
        if (!widget.isFilled) return;
        await squeezeAnimation();
        await widget.onTap();
      },
      child: Container(
        height: widget.height ?? 40,
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: dynamicHeight,
            width: dynamicWidth,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(dynamicWidth == dynamicHeight ? 32 : 8),
              color: dynamicColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isFilled
                    ? dynamicColor
                    : widget.backgroudColor ?? Color(0xff1e1e1e),
                borderRadius: BorderRadius.circular(
                    dynamicWidth == dynamicHeight ? 32 : 6),
              ),
              child: Center(
                child: dynamicWidth == dynamicHeight
                    ? isProcessCompleted
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                    : Text(
                        widget.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSize ?? 12,
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
