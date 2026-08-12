// ignore_for_file: strict_top_level_inference

import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:flutter/services.dart';

import '../consts/consts.dart';

Widget exitDialog(context) {
  return Dialog(
    child:
        Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                "Confirm".text
                    .fontFamily(bold)
                    .size(18)
                    .color(darkFontGrey)
                    .make(),
                const Divider(),
                10.heightBox,
                "Are you sure you want to exit?".text
                    .size(16)
                    .color(darkFontGrey)
                    .make(),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ourButton(
                      color: redColor,
                      onPress: () {
                        SystemNavigator.pop();
                      },
                      textColor: whiteColor,
                      title: "Yes",
                    ),
                    ourButton(
                      color: redColor,
                      onPress: () {
                        Navigator.pop(context);
                      },
                      textColor: whiteColor,
                      title: "no",
                    ),
                  ],
                ), // Row
              ],
            ).box
            .color(lightGrey)
            .padding(const EdgeInsets.all(12))
            .roundedSM
            .make(), // Column
  ); // Dialog
}
