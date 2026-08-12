import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:ecommerce_app/views/chat_screen/chats_screen.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    // CRITICAL FIX: If data is null, stop building and show an error state.
    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: "Error".text.make()),
        body: Center(
          child: "Product data could not be loaded.".text
              .color(darkFontGrey)
              .make(),
        ),
      );
    }

    // Safely extract lists to prevent crashes if they are missing
    List dynamicImgs = data["p_imgs"] ?? [];
    List dynamicColors = data["p_colors"] ?? [];

    // Safely extract price to prevent isNegative crash
    var rawPrice = data["p_price"];
    var safePrice = (rawPrice == null || rawPrice.toString().trim().isEmpty)
        ? "0"
        : rawPrice;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: (title ?? "Item Details").text
              .color(darkFontGrey)
              .fontFamily(bold)
              .make(),
          actions: [
            IconButton(
              tooltip: 'Share product',
              onPressed: () async {
                final productName = data['p_name'] ?? title ?? 'this product';
                await Clipboard.setData(
                  ClipboardData(text: 'Check out $productName on $appname.'),
                );
                VxToast.show(
                  context,
                  msg: 'Product details copied to clipboard',
                );
              },
              icon: const Icon(Icons.share),
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  if (controller.isFov.value) {
                    controller.removeFromWishlist(data.id, context);
                  } else {
                    controller.addToWishlist(data.id, context);
                  }
                },
                icon: Icon(
                  Icons.favorite,
                  color: controller.isFov.value ? redColor : darkFontGrey,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE SWIPER
                      if (dynamicImgs.isNotEmpty)
                        VxSwiper.builder(
                          autoPlay: true,
                          height: 350,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemCount: dynamicImgs.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              dynamicImgs[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                            );
                          },
                        )
                      else
                        const SizedBox(
                          height: 350,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      10.heightBox,

                      // TITLE
                      (title ?? "Product Name").text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,

                      // RATING
                      VxRating(
                        isSelectable: false,
                        value:
                            double.tryParse(data["p_rating"].toString()) ?? 0.0,
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        maxRating: 5,
                        size: 25,
                      ),
                      10.heightBox,

                      // PRICE (Using safePrice here to prevent crash)
                      "$safePrice".numCurrency.text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,

                      // SELLER INFO
                      Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    'Seller'.text.white
                                        .fontFamily(semibold)
                                        .make(),
                                    5.heightBox,
                                    "${data["p_seller"] ?? 'Unknown'}".text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .size(16)
                                        .make(),
                                  ],
                                ),
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.message_rounded,
                                  color: darkFontGrey,
                                ),
                              ).onTap(() {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: [
                                    data["p_seller"],
                                    data["vendor_id"],
                                  ],
                                );
                              }),
                            ],
                          ).box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(darkFontGrey)
                          .make(),
                      20.heightBox,

                      // COLORS & QUANTITY
                      Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Color: ".text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Row(
                                  children: List.generate(
                                    dynamicColors.length,
                                    (index) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        VxBox()
                                            .size(40, 40)
                                            .roundedFull
                                            .color(
                                              Color(
                                                dynamicColors[index],
                                              ).withValues(alpha: 1),
                                            )
                                            .margin(
                                              const EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                            )
                                            .make()
                                            .onTap(() {
                                              controller.changeColorIndex(
                                                index,
                                              );
                                            }),
                                        Visibility(
                                          visible:
                                              index ==
                                              controller.colorIndex.value,
                                          child: const Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity: ".text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.decreaseQuantity();
                                        controller.calculateTotalPrice(
                                          int.tryParse(safePrice.toString()) ??
                                              0,
                                        );
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    controller.quantity.value.text
                                        .size(16)
                                        .color(darkFontGrey)
                                        .fontFamily(bold)
                                        .make(),
                                    IconButton(
                                      onPressed: () {
                                        controller.increaseQuantity(
                                          int.tryParse(
                                                data["p_quantity"].toString(),
                                              ) ??
                                              0,
                                        );
                                        controller.calculateTotalPrice(
                                          int.tryParse(safePrice.toString()) ??
                                              0,
                                        );
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                    10.widthBox,
                                    "(${data["p_quantity"] ?? 0} available)"
                                        .text
                                        .color(textfieldGrey)
                                        .make(),
                                  ],
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total: ".text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .color(redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make(),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ],
                        ).box.white.shadowSm.make(),
                      ),
                      10.heightBox,

                      // DESCRIPTION
                      "Description".text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data["p_desc"] ?? 'No description available.'}".text
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                      // Safe color extraction
                      color: dynamicColors.isNotEmpty
                          ? dynamicColors[controller.colorIndex.value]
                          : 0xFF000000, // Default fallback color if array is empty
                      context: context,
                      vendorID: data['vendor_id'] ?? "",
                      // Safe image extraction
                      img: dynamicImgs.isNotEmpty ? dynamicImgs[0] : "",
                      qty: controller.quantity.value,
                      sellername: data['p_seller'] ?? "Unknown",
                      title: data['p_name'] ?? "Unknown Product",
                      tprice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context, msg: "Minimum 1 product is required");
                  }
                },
                textColor: whiteColor,
                title: "Add to Cart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
