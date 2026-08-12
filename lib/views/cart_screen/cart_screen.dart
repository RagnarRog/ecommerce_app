import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/views/cart_screen/shipping_details.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';
// Make sure to import your ShippingDetails screen here
// import 'package:ecommerce_app/views/cart_screen/shipping_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Obx(
          () => ourButton(
            color: controller.totalP.value > 0 ? redColor : lightGrey,
            onPress: () {
              if (controller.totalP.value > 0) {
                Get.to(() => const ShippingDetails());
              }
            },
            textColor: whiteColor,
            title: "Proceed to shipping",
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping cart".text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.calculate(data);
              controller.productSnapshot = data;
            });

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        // NULL FIX: Safely check if fields exist in the document first
                        var docData =
                            data[index].data() as Map<String, dynamic>? ?? {};
                        var img = docData.containsKey('img')
                            ? docData['img']
                            : '';
                        var title = docData.containsKey('title')
                            ? docData['title']
                            : 'Unknown';
                        var tprice = docData.containsKey('tprice')
                            ? docData['tprice']
                            : 0;

                        return ListTile(
                          leading: img.toString().isEmpty
                              ? const Icon(Icons.image_not_supported)
                              : Image.network(
                                  "${data[index]["img"]}",
                                  width: 80,
                                  fit: BoxFit.fill,
                                ),
                          title: "$title".text
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                          subtitle: "$tprice".numCurrency.text
                              .color(redColor)
                              .fontFamily(semibold)
                              .make(),
                          trailing: const Icon(Icons.delete, color: redColor)
                              .onTap(() {
                                FirestorServices.deleteDocument(data[index].id);
                              }),
                        );
                      },
                    ),
                  ),
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Total Price".text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          Obx(
                            () => "${controller.totalP.value}".numCurrency.text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                          ),
                        ],
                      ).box
                      .padding(const EdgeInsets.all(12))
                      .color(lightGolden)
                      .width(context.screenWidth - 60)
                      .roundedSM
                      .make(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
