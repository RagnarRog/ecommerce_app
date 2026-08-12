import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';

import '../../consts/consts.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Wishlist".text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ), // AppBar
      body: StreamBuilder(
        stream: FirestorServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator()); // Center
          } else if (snapshot.data!.docs.isEmpty) {
            return "No orders yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var docData =
                          data[index].data() as Map<String, dynamic>? ?? {};

                      // NOTE: Check your Firestore field names!
                      // If Wishlist uses 'p_name' instead of 'title', change these keys.
                      var img = docData.containsKey('p_imgs')
                          ? docData['p_imgs']
                          : '';
                      // ignore: unused_local_variable
                      var title = docData.containsKey('p_name')
                          ? docData['p_name']
                          : 'Unknown';
                      // ignore: unused_local_variable
                      var tprice = docData.containsKey('p_price')
                          ? docData['p_price']
                          : 0;
                      return ListTile(
                        leading: img.toString().isEmpty
                            ? const Icon(Icons.image_not_supported)
                            : Image.network(
                                "${data[index]["p_imgs"][0]}",
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                        title: "${data[index]["p_name"]}".text
                            .fontFamily(semibold)
                            .size(16)
                            .make(),
                        subtitle: "${data[index]["p_price"]}".numCurrency.text
                            .color(redColor)
                            .fontFamily(semibold)
                            .make(),
                        trailing: const Icon(Icons.favorite, color: redColor)
                            .onTap(() async {
                              await firestore
                                  .collection(productsCollection)
                                  .doc(data[index].id)
                                  .set({
                                    "p_wishlist": FieldValue.arrayRemove([
                                      currentUser!.uid,
                                    ]),
                                  }, SetOptions(merge: true));
                            }),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
