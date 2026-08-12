import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';

import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;
  var isLoading = false.obs;

  Future<void> getChatId() async {
    isLoading(true);

    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
            chats.doc(chatDocId).set({
              'user_ids': [currentId, friendId],
            }, SetOptions(merge: true));
          } else {
            chats
                .add({
                  'created_on': null,
                  'last_msg': '',
                  'users': {friendId: null, currentId: null},
                  'user_ids': [currentId, friendId],
                  'toId': '',
                  'fromId': '',
                  'friend_name': friendName,
                  'sender_name': senderName,
                })
                .then((value) {
                  chatDocId = value.id;
                });
          }
        });
    isLoading(false);
  }

  Future<void> sendMsg(String msg) async {
    final text = msg.trim();
    if (text.isEmpty || chatDocId == null) return;
    await chats.doc(chatDocId).update({
      'created_on': FieldValue.serverTimestamp(),
      'last_msg': text,
      'toId': friendId,
      'fromId': currentId,
      'user_ids': [currentId, friendId],
    });
    await chats.doc(chatDocId).collection(messageCollection).doc().set({
      'created_on': FieldValue.serverTimestamp(),
      'msg': text,
      'uid': currentId,
    });
  }
}
