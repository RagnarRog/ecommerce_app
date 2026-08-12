import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:ecommerce_app/views/orders_screen/order_details.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ), // AppBar
      body: StreamBuilder(
        stream:
            FirestorServices.getAllOrders(), // Undefined name 'stream'. Try correcting the name to one that is defined,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator()); // Center
          } else if (snapshot.data!.docs.isEmpty) {
            return "No orders yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: "${index + 1}".text
                      .fontFamily(bold)
                      .color(darkFontGrey)
                      .xl
                      .make(),
                  title: data[index]['order_code']
                      .toString()
                      .text
                      .color(redColor)
                      .fontFamily(semibold)
                      .make(),
                  subtitle: data[index]['total_amount']
                      .toString()
                      .numCurrency
                      .text
                      .fontFamily(bold)
                      .make(),
                  trailing: IconButton(
                    tooltip: 'View order details',
                    onPressed: () =>
                        Get.to(() => OrderDetails(data: data[index])),
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: darkFontGrey,
                    ), // Icon
                  ), // IconButton
                ); // ListTile
              },
            ); // ListView.builder
          }
        },
      ), // StreamBuilder
    ); // Scaffold
  }
}
