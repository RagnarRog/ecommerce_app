// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/custom_textfield.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, this.data});

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(
          () =>
              Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data["imageUrl"] == "" &&
                              controller.profileImgPath.isEmpty
                          ? Image.asset(
                              imgProfile2,
                              width: 100,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : data["imageUrl"] != "" &&
                                controller.profileImgPath.isEmpty
                          ? Image.network(
                              data["imageUrl"],
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    imgProfile2,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.file(
                              File(controller.profileImgPath.value),
                              width: 100,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                      10.heightBox,
                      ourButton(
                        color: redColor,
                        onPress: () {
                          controller.changeImage(context);
                        },
                        textColor: whiteColor,
                        title: "Change",
                      ),
                      const Divider(),
                      20.heightBox,
                      customTextField(
                        controller: controller.nameController,
                        hint: nameHint,
                        title: name,
                        isPass: false,
                      ),
                      10.heightBox,
                      customTextField(
                        controller: controller.oldpassController,
                        hint: passwordHint,
                        title: oldpass,
                        isPass: true,
                      ),
                      10.heightBox,
                      customTextField(
                        controller: controller.newpassController,
                        hint: passwordHint,
                        title: newpass,
                        isPass: true,
                      ),
                      20.heightBox,
                      controller.isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            )
                          : SizedBox(
                              width: context.screenWidth - 60,
                              child: ourButton(
                                color: redColor,

                                onPress: () async {
                                  controller.isLoading(true);
                                  try {
                                    final newPassword =
                                        controller.newpassController.text;
                                    final oldPassword =
                                        controller.oldpassController.text;
                                    if (newPassword.isNotEmpty ||
                                        oldPassword.isNotEmpty) {
                                      if (oldPassword.isEmpty ||
                                          newPassword.length < 6) {
                                        throw StateError(
                                          'Enter your current password and a new password of at least 6 characters.',
                                        );
                                      }
                                      await controller.changeAuthPassword(
                                        email: data['email'],
                                        password: oldPassword,
                                        newpassword: newPassword,
                                      );
                                    }
                                    final imageUrl =
                                        controller.profileImgPath.isNotEmpty
                                        ? await controller.uploadProfileImage()
                                        : data['imageUrl'].toString();
                                    await controller.updateProfile(
                                      name: controller.nameController.text
                                          .trim(),
                                      imageUrl: imageUrl,
                                    );
                                    VxToast.show(context, msg: "Updated");
                                    Get.back();
                                  } catch (error) {
                                    VxToast.show(
                                      context,
                                      msg: error.toString(),
                                    );
                                  } finally {
                                    controller.isLoading(false);
                                  }
                                },
                                textColor: whiteColor,
                                title: "save",
                              ),
                            ),
                    ],
                  ).box.white.shadowSm
                  .padding(EdgeInsets.all(16))
                  .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
                  .rounded
                  .make(),
        ),
      ), // Scaffold
    );
  }
}
