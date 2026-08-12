import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/orders_screen/components/order_place_details.dart';
import 'package:ecommerce_app/views/orders_screen/components/order_status.dart';
import "package:intl/intl.dart";

class OrderDetails extends StatelessWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details".text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ), // AppBar
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                color: redColor,
                icon: Icons.done,
                title: "placed",
                showDone: data['order_placed'] ?? false,
              ),
              orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Confirmed",
                showDone: data['order_confirmed'] ?? false,
              ),
              orderStatus(
                color: Colors.yellow,
                icon: Icons.car_crash,
                title: "on delivery",
                showDone: data['order_on_delivery'] ?? false,
              ),
              orderStatus(
                color: Colors.purple,
                icon: Icons.done_all_rounded,
                title: "delivered",
                showDone: data['order_delivered'] ?? false,
              ),
              Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                    data['order_code'],
                    data['shipping_method'],
                    "Order Code",
                    "Shipping Method",
                  ),
                  orderPlaceDetails(
                    data['order_date'] == null
                        ? 'Processing date…'
                        : DateFormat(
                            "h:mma",
                          ).add_yMd().format(data['order_date'].toDate()),
                    data['payment_method'],
                    "Order Date",
                    "Payment Method",
                  ),
                  orderPlaceDetails(
                    data['payment_status']?.toString() ?? "Pending",
                    data['order_delivered'] == true
                        ? 'Delivered'
                        : data['order_on_delivery'] == true
                        ? 'On delivery'
                        : data['order_confirmed'] == true
                        ? 'Confirmed'
                        : 'Order placed',
                    "Payment Status",
                    "Delivery Status",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "shipping adress".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          height: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "total amount".text.fontFamily(semibold).make(),
                              "${data["total_amount"]}".text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(),
              10.heightBox,
              "Ordered Product".text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              10.heightBox,
              ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(data['orders'].length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          orderPlaceDetails(
                            data['orders'][index]['title'],
                            data['orders'][index]['tprice'],
                            "${data['orders'][index]['qty']}x",
                            "Refundable",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: 30,
                              height: 20,
                              color: Color(data['orders'][index]['color']),
                            ),
                          ), // Container
                          const Divider(),
                        ],
                      ); // Column
                    }).toList(),
                  ).box.outerShadowMd.white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              20.heightBox,
              Row(
                children: [
                  "SUB TOTAL:".text
                      .size(16)
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .make(),
                ],
              ), // Row
            ],
          ),
        ),
      ), // Column
    ); // Scaffold
  }
}
