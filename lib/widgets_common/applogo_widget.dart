import 'package:ecommerce_app/consts/consts.dart';

Widget applogoWidget() {
  return Image.asset(
    icAppLogo,
    fit: BoxFit.cover,
  ).box.size(80, 80).rounded.clip(Clip.antiAlias).make();
}
