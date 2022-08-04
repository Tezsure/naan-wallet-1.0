import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/controllers/beacon_form_controller.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';

Widget getPlentyNaanConnectionUI(BeaconFormController controller,
    {bool showNames = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            controller.argsModel.value.appMetadata.icon != null
                ? Container(
                    height: Get.height * 0.06,
                    width: Get.height * 0.06,
                    child: CacheImageBuilder(
                        imageUrl: controller.argsModel.value.appMetadata.icon),
                  )
                : Container(
                    height: Get.height * 0.06,
                    width: Get.height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          300,
                        ),
                      ),
                      color: dialogBackgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        controller.argsModel.value.appMetadata.name
                            .split('')[0]
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff7F8489),
                        ),
                      ),
                    ),
                  ),
            showNames
                ? Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        controller.argsModel.value.appMetadata.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff7F8489),
                        ),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: showNames ? Get.height * 0.04 : 0,
                left: showNames ? 0 : 12,
                right: showNames ? 0 : 12),
            child: Container(
                height: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(.36),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: gradientBackground,
                      ),
                      child: Center(
                        child: Icon(Icons.check,
                            size: 12, color: Color(0xff1e1e1e)),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.36),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/icon/naan_oval.png",
                fit: BoxFit.scaleDown,
                height: Get.height * 0.06,
                width: Get.height * 0.06,
              ),
            ),
            showNames
                ? Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Naan Wallet",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff7F8489),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ],
    ),
  );
}
