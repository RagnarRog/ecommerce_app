import 'package:ecommerce_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // ignore: strict_top_level_inference
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method

  Future<UserCredential?> signupMethod({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      VxToast.show(context, msg: error.message ?? 'Could not create account');
      return null;
    }
  }

  Future<bool> sendPasswordReset({required BuildContext context}) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      VxToast.show(context, msg: 'Enter your email address first');
      return false;
    }
    try {
      await auth.sendPasswordResetEmail(email: email);
      VxToast.show(context, msg: 'Password reset email sent');
      return true;
    } on FirebaseAuthException catch (error) {
      VxToast.show(context, msg: error.message ?? 'Could not send reset email');
      return false;
    }
  }

  Future<void> storeUserData({
    required User user,
    required String name,
    required String email,
  }) async {
    await firestore.collection(usersCollection).doc(user.uid).set({
      "name": name,
      "email": email,
      "imageUrl": "",
      "id": user.uid,
      "cart_count": "00",
      "wishlist_count": "00",
      "order_count": "00",
    });
  }

  // ignore: strict_top_level_inference
  Future<void> signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
