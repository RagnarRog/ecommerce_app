import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;

  const CategoryDetails({super.key, this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    final title = widget.title ?? '';
    try {
      await controller.getSubCategories(title);
      switchCategory(title);
    } catch (error) {
      loadError = error;
    } finally {
      if (mounted) setState(() {});
    }
  }

  void switchCategory(String title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestorServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestorServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  Stream<QuerySnapshot<Map<String, dynamic>>>? productMethod;
  Object? loadError;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: (widget.title ?? categories).text.fontFamily(bold).make(),
        ), // AppBar
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.subcat.length,
                  (index) => controller.subcat[index].text
                      .size(12)
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .makeCentered()
                      .box
                      .white
                      .rounded
                      .size(120, 50)
                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                      .make()
                      .onTap(() {
                        // ignore: unnecessary_string_interpolations
                        switchCategory(("${controller.subcat[index]}"));
                        setState(() {});
                      }),
                ), //
              ),
            ),
            20.heightBox,
            if (loadError != null)
              Expanded(
                child: Center(
                  child: 'Could not load products. Please try again.'.text
                      .color(darkFontGrey)
                      .make(),
                ),
              )
            else if (productMethod == null)
              Expanded(child: Center(child: loadingIndicator()))
            else
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: productMethod!,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          child: Center(child: loadingIndicator()),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: "No products found!".text
                              .color(darkFontGrey)
                              .makeCentered(),
                        );
                      } else {
                        var data = snapshot.data!.docs;
                        return Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 250,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                            itemBuilder: (context, index) {
                              var docData = data[index].data();

                              // Safety check for images
                              final images = docData['p_imgs'];
                              final hasImages =
                                  images is List && images.isNotEmpty;

                              // Safety check for price parsing (prevents isNegative crash)
                              var rawPrice = docData['p_price'];
                              var safePrice =
                                  (rawPrice == null ||
                                      rawPrice.toString().trim().isEmpty)
                                  ? "0"
                                  : rawPrice;

                              return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      hasImages
                                          ? Image.network(
                                              images.first.toString(),
                                              height: 150,
                                              width: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) =>
                                                      _productImagePlaceholder(),
                                            )
                                          : Container(
                                              height: 150,
                                              width: 200,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      const Spacer(),
                                      "${docData["p_name"] ?? "Unnamed product"}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      // Replaced vulnerable price string with safePrice
                                      "$safePrice".numCurrency.text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                    ],
                                  ).box.white
                                  .margin(
                                    const EdgeInsets.symmetric(horizontal: 4),
                                  )
                                  .roundedSM
                                  .outerShadowSm
                                  .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(() {
                                    controller.checkIfFav(docData);
                                    Get.to(
                                      () => ItemDetails(
                                        title:
                                            "${docData["p_name"] ?? "Product"}",
                                        data: data[index],
                                      ),
                                    );
                                  });
                            },
                          ),
                        );
                      }
                    },
              ),
          ],
        ),
      ),
    );
  }
}

Widget _productImagePlaceholder() => Container(
  height: 150,
  width: 200,
  color: lightGrey,
  child: const Icon(Icons.image_not_supported, color: fontGrey),
);
