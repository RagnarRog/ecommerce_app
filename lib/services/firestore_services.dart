// ignore_for_file: strict_top_level_inference

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';

class FirestorServices {
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where("p_category", isEqualTo: category)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where("added_by", isEqualTo: uid)
        .snapshots();
  }

  static Future<void> deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where("order_by", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getWishlists() {
    return firestore
        .collection(productsCollection)
        .where("p_wishlist", arrayContains: currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where("user_ids", arrayContains: currentUser!.uid)
        .snapshots();
  }

  static Future<List<int>> getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
            return value.docs.length;
          }),
      firestore
          .collection(productsCollection)
          .where("p_wishlist", arrayContains: currentUser!.uid)
          .get()
          .then((value) {
            return value.docs.length;
          }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
            return value.docs.length;
          }),
    ]);
    return res;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> allproducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  //get featured products method
  static Future<QuerySnapshot<Map<String, dynamic>>> getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where("is_featured", isEqualTo: true)
        .get();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSubCategoryProducts(
    String title,
  ) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }
}
