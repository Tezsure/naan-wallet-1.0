// import 'package:clay_containers/clay_containers.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';

// // ignore: must_be_immutable
// class RecoveryPhraseDetailView extends StatelessWidget {
//   var controller;

//   RecoveryPhraseDetailView({this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: EdgeInsets.only(
//           top: 40.0,
//         ),
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 margin: EdgeInsets.only(
//                   bottom: Get.height * 0.15,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       "assets/recovery_phrase/detail_image.png",
//                       width: Get.width * 0.6,
//                     ),
//                     Text(
//                       "Reveal Seed Phrase",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 30,
//                         color: Color(
//                           0xFFFDFDFD,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 13.0,
//                     ),
//                     Container(
//                       width: Get.width * 0.75,
//                       child: Text(
//                         "I understand that if I lose my reveal seed phrase, I will not be able to regain access to my wallet if I lose or unpair my device.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 20,
//                           color: Color(
//                             0xFF7F8489,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.only(
//                   bottom: Get.height * 0.01,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     GestureDetector(
//                       onTap: () => controller.viewIndex.value++,
//                       child: ClayContainer(
//                         width: Get.width - 50,
//                         height: 55.0,
//                         color: Color(
//                           0xFF323840,
//                         ),
//                         surfaceColor: Color(0xFF262b30),
//                         borderRadius: 22,
//                         depth: 20,
//                         spread: 2,
//                         child: Center(
//                           child: Text(
//                             "Show reveal seed phrase",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Material(
//                       //   color: Colors.transparent,
//                       //   shadowColor: Colors.white.withOpacity(0.1),
//                       //   borderRadius: BorderRadius.all(
//                       //     Radius.circular(
//                       //       22.0,
//                       //     ),
//                       //   ),
//                       //   elevation: 10.0,
//                       //   child: Container(
//                       //     width: Get.width - 50,
//                       //     height: 55.0,
//                       //     decoration: BoxDecoration(
//                       //       borderRadius: BorderRadius.all(
//                       //         Radius.circular(
//                       //           22.0,
//                       //         ),
//                       //       ),
//                       //       gradient: LinearGradient(
//                       //         stops: [0.14, 0.84],
//                       //         colors: <Color>[
//                       //           Color(0xFF2F353A),
//                       //           Color(0xFF1C1F22),
//                       //         ],
//                       //       ),
//                       //     ),
//                       //     alignment: Alignment.center,
//                       //     child: Text(
//                       //       "Show recovery phrase",
//                       //       style: TextStyle(
//                       //         color: Colors.white,
//                       //         fontWeight: FontWeight.w500,
//                       //         fontSize: 18,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                     ),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
