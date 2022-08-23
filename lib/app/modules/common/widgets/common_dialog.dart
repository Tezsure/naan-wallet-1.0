import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';

// ignore: must_be_immutable
class CommonDialog extends StatefulWidget {
  String title;
  String desc;
  String image;
  String buttonText;
  var onButtonClick;

  CommonDialog(
      {this.title, this.desc, this.image, this.buttonText, this.onButtonClick});

  @override
  _CommonDialogState createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        width: 350,
        padding: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(child: Container()),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Color(0xFFFDFDFD),
                    size: 30.0,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(
                  width: 6.0,
                )
              ],
            ),
            Image.asset(
              widget.image,
              width: 90,
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: Color(
                  0xFFFDFDFD,
                ),
                fontWeight: FontWeight.w700,
                fontSize: 28.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                top: 20.0,
                bottom: 20.0,
              ),
              child: Text(
                widget.desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(
                    0xFF7F8489,
                  ),
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: widget.onButtonClick,
              child: ClayContainer(
                width: 250,
                height: 55.0,
                color: Color(
                  0xFF323840,
                ),
                surfaceColor: backgroundColor,
                borderRadius: 22,
                depth: 20,
                spread: 4,
                child: Center(
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
          ],
        ),
      ),
    );
  }
}
