// ignore_for_file: deprecated_member_use

import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:ecommerce_app/views/category_screen/category_screen.dart';
import 'package:ecommerce_app/views/cart_screen/cart_screen.dart';
import 'package:ecommerce_app/views/home_screen/home_screen.dart';
import 'package:ecommerce_app/views/profile_screen/profile_screen.dart';
import 'package:ecommerce_app/widgets_common/exit_dialog.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final HomeController controller;
  late final List<Widget> navBody;
  bool exitDialogOpen = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    Get.put(ProductController());
    navBody = const [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var navbarItem = [
      BottomNavigationBarItem(
        icon: Image.asset(icHome, width: 26),
        label: home,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCategories, width: 26),
        label: categories,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCart, width: 26),
        label: cart,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icProfile, width: 26),
        label: account,
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentNavIndex.value != 0) {
          controller.currentNavIndex.value = 0;
          return false;
        }
        if (exitDialogOpen) return false;
        exitDialogOpen = true;
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        exitDialogOpen = false;
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            // Obx tells Flutter to rebuild this specific part when currentNavIndex changes
            Obx(
              () => Expanded(
                child: IndexedStack(
                  index: controller.currentNavIndex.value,
                  children: navBody,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            // CRITICAL: You must tell the bar which item is selected
            currentIndex: controller.currentNavIndex.value,

            selectedItemColor: redColor,
            unselectedItemColor: fontGrey,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            elevation: 12,
            items: navbarItem,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
