import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/views/cart_screen/payment_method.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

import '../../widgets_common/custom_textfield.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ), // AppBar
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.trim().length > 10 &&
                controller.cityController.text.trim().isNotEmpty &&
                controller.stateController.text.trim().isNotEmpty &&
                controller.postalcodeController.text.trim().isNotEmpty &&
                controller.phoneController.text.trim().length >= 7) {
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
              hint: "Address",
              isPass: false,
              title: "Address",
              controller: controller.addressController,
            ),
            customTextField(
              hint: "City",
              isPass: false,
              title: "City",
              controller: controller.cityController,
            ),
            customTextField(
              hint: "State",
              isPass: false,
              title: "State",
              controller: controller.stateController,
            ),
            customTextField(
              hint: "Postal Code",
              isPass: false,
              title: "Postal Code",
              controller: controller.postalcodeController,
            ),
            customTextField(
              hint: "Phone",
              isPass: false,
              title: "Phone",
              controller: controller.phoneController,
            ),
          ],
        ), // Column
      ),
    ); // Scaffold
  }
}
