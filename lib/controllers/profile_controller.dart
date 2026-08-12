import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "package:path/path.dart";

class ProfileController extends GetxController {
  var profileImgPath = ''.obs;
  var profileImageLink = "";
  var isLoading = false.obs;

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  Future<void> changeImage(BuildContext context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Usually set to 70-80 to reduce file size
      );

      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      // It's good practice to show a snackbar if something goes wrong
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<String> uploadProfileImage() async {
    final user = currentUser;
    if (user == null || profileImgPath.value.isEmpty) {
      throw StateError('Please choose an image before uploading.');
    }
    final file = File(profileImgPath.value);
    if (!await file.exists()) {
      throw StateError('The selected image is no longer available.');
    }
    final filename =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
    final destination = 'profile_images/${user.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(file);
    profileImageLink = await ref.getDownloadURL();
    return profileImageLink;
  }

  Future<void> updateProfile({
    required String name,
    required String imageUrl,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('You are signed out. Please sign in again.');
    }
    await firestore.collection(usersCollection).doc(user.uid).set({
      "name": name,
      "imageUrl": imageUrl,
    }, SetOptions(merge: true));
  }

  Future<void> changeAuthPassword({
    required String email,
    required String password,
    required String newpassword,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('You are signed out. Please sign in again.');
    }
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newpassword);
  }
}
