// ignore_for_file: strict_top_level_inference

import 'package:ecommerce_app/consts/consts.dart';

Widget homeButtons({width, height, icon, String? title, onPress}) {
  final button =
      Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, width: 26),
              10.heightBox,
              title!.text.fontFamily(semibold).color(darkFontGrey).make(),
            ],
          )
          .box // This creates the Container
          .rounded
          .white
          .size(width, height) // These dimensions handle the sizing now
          .make();
  return onPress == null ? button : button.onTap(onPress);
}
