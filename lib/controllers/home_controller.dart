import 'package:ecommerce_app/consts/consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var currentNavIndex = 0.obs;
  var username = '';

  var featuredList = [];
  var searchController = TextEditingController();

  Future<void> getUsername() async {
    final user = currentUser;
    if (user == null) return;
    final profile = await firestore
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    username =
        profile.data()?['name']?.toString() ??
        user.email?.split('@').first ??
        'Customer';
  }
}
