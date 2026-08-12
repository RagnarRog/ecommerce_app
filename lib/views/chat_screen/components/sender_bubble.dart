import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';

Widget senderBubble(DocumentSnapshot data) {
  // ignore: unused_local_variable
  var t = data["created_on"] == null
      ? DateTime.now()
      : data["created_on"].toDate();

  return Directionality(
    textDirection: data["uid"] == currentUser!.uid
        ? TextDirection.rtl
        : TextDirection.ltr,
    child: Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: data["uid"] == currentUser!.uid ? redColor : darkFontGrey,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data["msg"]}.".text.white.size(16).make(),
          10.heightBox,
          // ignore: deprecated_member_use
          "11:45 PM".text.color(whiteColor.withOpacity(0.5)).make(),
        ],
      ),
    ),
  );
}
