import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget backButton(BuildContext context, {Function ontap}) {
  return GestureDetector(
    onTap: () => ontap == null ? Navigator.pop(context) : ontap(),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Color(0xFF1C1F22),
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.04),
              offset: Offset(-2, -2),
              blurRadius: 8),
          BoxShadow(
              color: Color(0xFF1C1F22), offset: Offset(2, 2), blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          "assets/tran_history/back_arrow.svg",
        ),
      ),
    ),
  );
}
