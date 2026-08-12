import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/chat_screen/messaging_screen.dart';
import 'package:ecommerce_app/views/orders_screen/order_screen.dart';
import 'package:ecommerce_app/views/profile_screen/components/details_card.dart';
import 'package:ecommerce_app/views/profile_screen/components/edit_profile_screen.dart';
import 'package:ecommerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestorServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ), // CircularProgressIndicator
                  ); // Center
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: 'Profile could not be found'.text
                        .color(darkFontGrey)
                        .make(),
                  );
                } else {
                  var data = snapshot.data!.docs[0];
                  return SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: const Icon(Icons.edit, color: darkFontGrey)
                                .onTap(() {
                                  controller.nameController.text = data["name"];

                                  Get.to(() => EditProfileScreen(data: data));
                                }),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              data["imageUrl"] == ""
                                  ? Image.asset(
                                          imgProfile2,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ).box.roundedFull
                                        .clip(Clip.antiAlias)
                                        .make()
                                  : Image.network(
                                          data["imageUrl"],
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    imgProfile2,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                        ).box.roundedFull
                                        .clip(Clip.antiAlias)
                                        .make(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "${data["name"]}".text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    "${data["email"]}".text
                                        .color(fontGrey)
                                        .make(),
                                  ],
                                ), // Column
                              ), // Expanded
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: redColor,
                                  ), // BorderSide
                                ),
                                onPressed: () async {
                                  await Get.put(
                                    AuthController(),
                                  ).signoutMethod(context);
                                  Get.offAll(() => LoginScreen());
                                },
                                child: logout.text
                                    .fontFamily(semibold)
                                    .color(redColor)
                                    .make(),
                              ), // OutlinedButton
                            ],
                          ),
                        ), // Row

                        20.heightBox,

                        FutureBuilder(
                          future: FirestorServices.getCounts(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: loadingIndicator());
                                } else {
                                  var countdata = snapshot.data;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      detailsCard(
                                        context.screenWidth / 3.4,
                                        countdata[0].toString(),
                                        "in your cart",
                                      ),
                                      detailsCard(
                                        context.screenWidth / 3.4,
                                        countdata[1].toString(),
                                        "in your wishlist",
                                      ),
                                      detailsCard(
                                        context.screenWidth / 3.5,
                                        countdata[2].toString(),
                                        "your orders",
                                      ),
                                    ],
                                  );
                                }
                              },
                        ),

                        ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return const Divider(color: lightGrey);
                              },
                              itemCount: profileButtonsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        Get.to(() => const OrderScreen());
                                        break;
                                      case 1:
                                        Get.to(() => const WishlistScreen());
                                        break;
                                      case 2:
                                        Get.to(() => const MessagesScreen());
                                        break;
                                    }
                                  },
                                  leading: Image.asset(
                                    profileButonsIcon[index],
                                    width: 22,
                                  ),
                                  title: profileButtonsList[index].text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                ); // ListTile
                              },
                            ).box.white.rounded
                            .margin(const EdgeInsets.all(12))
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .shadowSm
                            .make()
                            .box
                            .color(redColor)
                            .make(),
                      ],
                    ), // Container
                  );
                } // Container
              },
        ), // StreamBuilder
      ), // Scaffold
    );
  }
}
