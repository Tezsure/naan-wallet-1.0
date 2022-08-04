import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/controllers/recover_wallet_controller.dart';

// ignore: must_be_immutable
class ChooseRecoverType extends StatefulWidget {
  RecoverWalletController controller;

  ChooseRecoverType(this.controller);

  @override
  _ChooseRecoverTypeState createState() => _ChooseRecoverTypeState();
}

class _ChooseRecoverTypeState extends State<ChooseRecoverType> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 5.0,
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => widget.controller.viewController.value++,
            child: Container(
              width: Get.width * 0.9,
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
                gradient: LinearGradient(
                  stops: [0.1, 0.84],
                  colors: <Color>[
                    Color(0xFF3D4148),
                    Color(0xFF3D4148),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seed phrase recovery",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  ClayContainer(
                    width: Get.width * 0.09,
                    height: Get.width * 0.09,
                    borderRadius: 200,
                    depth: 20,
                    spread: 1,
                    emboss: true,
                    color: backgroundColor,
                    curveType: CurveType.convex,
                    child: Transform.translate(
                      offset: Offset(0.0, 0.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF7F8489),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Material(
          elevation: 5.0,
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => widget.controller.viewController.value += 2,
            child: Container(
              width: Get.width * 0.9,
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
                gradient: LinearGradient(
                  stops: [0.1, 0.84],
                  colors: <Color>[
                    Color(0xFF3D4148),
                    Color(0xFF3D4148),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Private key recovery",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  ClayContainer(
                    width: Get.width * 0.09,
                    height: Get.width * 0.09,
                    borderRadius: 200,
                    depth: 20,
                    spread: 1,
                    emboss: true,
                    color: backgroundColor,
                    curveType: CurveType.convex,
                    child: Transform.translate(
                      offset: Offset(0.0, 0.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF7F8489),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Material(
        //   elevation: 5.0,
        //   color: Colors.transparent,
        //   child: Container(
        //     width: Get.width * 0.9,
        //     padding: EdgeInsets.only(
        //       top: 20.0,
        //       bottom: 20.0,
        //       left: 20.0,
        //       right: 20.0,
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(
        //           10.0,
        //         ),
        //       ),
        //       gradient: LinearGradient(
        //         stops: [0.1, 0.84],
        //         colors: <Color>[
        //           Color(0xFF3D4148),
        //           Color(0xFF3D4148),
        //         ],
        //       ),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 "Recover & migrate",
        //                 style: TextStyle(
        //                   fontSize: 17,
        //                   fontWeight: FontWeight.w700,
        //                   color: Colors.white,
        //
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 3.0,
        //               ),
        //               Text(
        //                 "For wallets created with magma for android prior to 18 oct 2020 ( v1.1.2 and earlier ).",
        //                 style: TextStyle(
        //                   fontSize: 10,
        //                   fontWeight: FontWeight.w400,
        //                   color: Color(0xFF7F8489),
        //
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 7.0,
        //               ),
        //               Text(
        //                 "A migration prompt will follow after wallet recovery.",
        //                 style: TextStyle(
        //                   fontSize: 10,
        //                   fontWeight: FontWeight.w400,
        //                   color: Color(0xFF7F8489),
        //
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         SizedBox(
        //           width: Get.width * 0.16,
        //         ),
        //         ClayContainer(
        //           width: Get.width * 0.09,
        //           height: Get.width * 0.09,
        //           borderRadius: 200,
        //           depth: 50,
        //           spread: 1,
        //           emboss: true,
        //           color: backgroundColor,
        //           curveType: CurveType.convex,
        //           child: Transform.translate(
        //             offset: Offset(0.0, 0.0),
        //             child: Icon(
        //               Icons.arrow_forward_ios_rounded,
        //               color: Color(0xFF7F8489),
        //               size: 20,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
