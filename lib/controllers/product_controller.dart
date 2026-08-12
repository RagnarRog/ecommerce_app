import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  // Explicitly typed Rx variables
  RxInt quantity = 0.obs;
  RxInt colorIndex = 0.obs;
  RxInt totalPrice = 0.obs;
  RxList<String> subcat = <String>[].obs;
  RxBool isFov = false.obs;

  // Added Future<void> and String type for title
  Future<void> getSubCategories(String title) async {
    subcat.clear();
    String data = await rootBundle.loadString(
      "lib/services/category_model.json",
    );
    CategoryModel decoded = categoryModelFromJson(data);

    // Filter categories
    List<Category> s = decoded.categories
        .where((Category element) => element.name == title)
        .toList();

    // Safety Check: Ensure the category was found before accessing index 0
    if (s.isNotEmpty) {
      for (String e in s[0].subcategory) {
        subcat.add(e);
      }
    }
  }

  // FIX: Added .value to update the RxInt correctly
  void changeColorIndex(int index) {
    colorIndex.value = index;
  }

  void increaseQuantity(int totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  // Assuming price is int based on totalPrice type
  void calculateTotalPrice(int price) {
    totalPrice.value = price * quantity.value;
  }

  // Added required types for named arguments
  Future<void> addToCart({
    required String title,
    required String img,
    required String sellername,
    required int color,
    required int qty,
    required int tprice,
    required BuildContext context,
    required String vendorID,
  }) async {
    await firestore
        .collection(cartCollection)
        .doc()
        .set({
          'title': title,
          'img': img,
          'sellername': sellername,
          'color': color,
          "vendor_id": vendorID,
          'qty': qty,
          'tprice': tprice,
          'added_by': currentUser!.uid,
        })
        .catchError((Object error) {
          // ignore: use_build_context_synchronously
          VxToast.show(context, msg: error.toString());
        });
  }

  void resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  Future<void> addToWishlist(String docId, BuildContext context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid]),
    }, SetOptions(merge: true));
    isFov(true);
    // ignore: use_build_context_synchronously
    VxToast.show(context, msg: 'Added to favorites');
  }

  Future<void> removeFromWishlist(String docId, BuildContext context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid]),
    }, SetOptions(merge: true));

    isFov(false);
    // ignore: use_build_context_synchronously
    VxToast.show(context, msg: 'Removed from favorites');
  }

  // Explicitly typing data as Map
  Future<void> checkIfFav(Map<String, dynamic> data) async {
    // Explicitly casting the wishlist to a List
    final wishlist = data['p_wishlist'];
    if (wishlist is! List) {
      isFov(false);
      return;
    }
    if (wishlist.contains(currentUser!.uid)) {
      isFov(true);
    } else {
      isFov(false);
    }
  }
}
