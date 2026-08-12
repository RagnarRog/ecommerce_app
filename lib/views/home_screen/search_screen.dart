import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../category_screen/item_details.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: (title ?? 'Search').text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
        future: FirestorServices.searchProducts(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return "no products found".text.makeCentered();
          } else {
            var data = snapshot.data!.docs;
            final query = title?.trim().toLowerCase() ?? '';
            var filtered = data
                .where(
                  (element) => element["p_name"]
                      .toString()
                      .toLowerCase()
                      .contains(query),
                )
                .toList();
            if (filtered.isEmpty) {
              return 'No products match your search'.text
                  .color(darkFontGrey)
                  .makeCentered();
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 300,
                ), // Sliv
                children: filtered
                    .mapIndexed(
                      (currentValue, index) =>
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _searchImage(
                                    filtered[index].data()
                                        as Map<String, dynamic>,
                                  ),
                                  const Spacer(),
                                  "${filtered[index]['p_name']}".text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  10.heightBox,
                                  "${filtered[index]['p_price']}".text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(16)
                                      .make(),
                                  10.heightBox,
                                ],
                              ).box.white.outerShadowMd
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                                Get.to(
                                  () => ItemDetails(
                                    title: "${filtered[index]["p_name"]}",
                                    data: filtered[index],
                                  ),
                                );
                              }),
                    )
                    .toList(), // Column
              ),
            ); // GridView
          }
        },
      ),
    ); // Scaffold
  }
}

Widget _searchImage(Map<String, dynamic> product) {
  final images = product['p_imgs'];
  if (images is! List || images.isEmpty) {
    return const SizedBox(
      height: 200,
      child: Center(child: Icon(Icons.image_not_supported)),
    );
  }
  return Image.network(
    images.first.toString(),
    height: 200,
    width: 200,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => const SizedBox(
      height: 200,
      child: Center(child: Icon(Icons.broken_image_outlined)),
    ),
  );
}
