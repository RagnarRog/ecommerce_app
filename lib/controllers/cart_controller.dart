import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();
  var paymentIndex = 0.obs;
  var products = [];
  var vendors = [];
  late dynamic productSnapshot;
  var placingOrder = false.obs;

  // ignore: strict_top_level_inference
  void calculate(data) {
    // FIX 1: Properly reset the total to 0 every time this runs
    totalP.value = 0;

    for (var i = 0; i < data.length; i++) {
      // FIX 2: Wrap in a try-catch and use tryParse for total safety
      try {
        // This will safely default to 0 if the price is missing or corrupted
        int itemPrice = int.tryParse(data[i]['tprice'].toString()) ?? 0;

        // FIX 3: Properly add the value to the Rx variable
        totalP.value += itemPrice;
      } catch (e) {
        // If something goes completely wrong with this specific item,
        // it just skips it instead of crashing the whole app.
      }
    }
  }

  // ignore: strict_top_level_inference
  void changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  // ignore: strict_top_level_inference
  Future<bool> placeMyOrer({
    required String orderPaymentMethod,
    required int totalAmount,
  }) async {
    placingOrder(true);
    try {
      getProducttDetails();
      await firestore.collection(ordersCollection).doc().set({
        "order_code": DateTime.now().millisecondsSinceEpoch,
        "order_date": FieldValue.serverTimestamp(),

        "order_by": currentUser!.uid,
        "order_by_name": Get.find<HomeController>().username,
        "order_by_email": currentUser!.email,
        "order_by_address": addressController.text,
        'order_by_state': stateController.text,
        'order_by_city': cityController.text,
        'order_by_phone': phoneController.text,
        "order_by_postalcode": postalcodeController.text,
        'shipping_method': "Home Delivery",
        'payment_method': orderPaymentMethod,
        'payment_status': orderPaymentMethod == cod
            ? 'Cash on delivery'
            : 'Pending',
        'order_placed': true,
        "order_confirmed": false,
        "order_delivered": false,
        "order_on_delivery": false,
        "total_amount": totalAmount,
        "orders": products,
        "vendors": vendors.toSet().toList(),
      });
      return true;
    } catch (error) {
      return false;
    } finally {
      placingOrder(false);
    }
  }

  void getProducttDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]["color"],
        "img": productSnapshot[i]["img"],
        "vendor_id": productSnapshot[i]["vendor_id"],
        "tprice": productSnapshot[i]["tprice"],
        "qty": productSnapshot[i]["qty"],
        "title": productSnapshot[i]["title"],
      });
      final vendorId = productSnapshot[i]["vendor_id"];
      if (vendorId != null && vendorId.toString().isNotEmpty) {
        vendors.add(vendorId);
      }
    }
  }

  void cleaerCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
