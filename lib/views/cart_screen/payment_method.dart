import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

import '../home_screen/home.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(child: loadingIndicator())
              : ourButton(
                  onPress: () async {
                    final placed = await controller.placeMyOrer(
                      orderPaymentMethod:
                          paymentMethods[controller.paymentIndex.value],
                      totalAmount: controller.totalP.value,
                    );
                    if (!placed) {
                      VxToast.show(context, msg: 'Could not place the order');
                      return;
                    }
                    controller.cleaerCart();
                    // ignore: use_build_context_synchronously
                    VxToast.show(context, msg: "Order placed succesfully");
                    Get.offAll(const Home());
                  },
                  color: redColor,
                  textColor: whiteColor,
                  title: "Place order",
                ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method".text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ), // AppBar
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.paymentIndex.value == index
                            ? redColor
                            : Colors.transparent,
                        width: 5,
                      ),
                    ),
                    margin: const EdgeInsets.all(12),
                    child: Stack(
                      alignment: AlignmentGeometry.topRight,
                      children: [
                        Image.asset(
                          paymentMethodsImg[index],
                          width: double.infinity,
                          height: 120,
                          colorBlendMode: controller.paymentIndex.value == index
                              ? BlendMode.darken
                              : BlendMode.color,
                          color: controller.paymentIndex.value == index
                              // ignore: deprecated_member_use
                              ? Colors.black.withOpacity(0.4)
                              : Colors.transparent,
                          fit: BoxFit.cover,
                        ),
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  activeColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      50,
                                    ),
                                  ),
                                  value: true,
                                  onChanged: (_) =>
                                      controller.changePaymentIndex(index),
                                ),
                              )
                            : Container(),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: paymentMethods[index].text.white
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    ); // Scaffold
  }
}
