import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/views/auth_screen/signup_screen.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/widgets_common/applogo_widget.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/custom_textfield.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            customTextField(
                              hint: emailHint,
                              title: email,
                              isPass: false,
                              controller: controller.emailController,
                            ),
                            customTextField(
                              hint: passwordHint,
                              title: password,
                              isPass: true,
                              controller: controller.passwordController,
                            ),
                            Align(
                              alignment: AlignmentGeometry.centerRight,
                              child: TextButton(
                                onPressed: () => controller.sendPasswordReset(
                                  context: context,
                                ),
                                child: forgetPass.text.make(),
                              ),
                            ),
                            5.heightBox,
                            // ourButton().box.width(context.screenWidth - 50).make(),
                            controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      redColor,
                                    ),
                                  )
                                : ourButton(
                                    color: redColor,
                                    title: login,
                                    textColor: whiteColor,
                                    onPress: () async {
                                      controller.isLoading(true);
                                      await controller
                                          .loginMethod(context: context)
                                          .then((value) {
                                            if (value != null) {
                                              VxToast.show(
                                                context,
                                                msg: loggedin,
                                              );
                                              Get.offAll(() => const Home());
                                            } else {
                                              controller.isLoading(false);
                                            }
                                          });
                                    },
                                  ).box.width(context.screenWidth - 50).make(),
                            5.heightBox,
                            createNewAccount.text.color(fontGrey).make(),
                            5.heightBox,
                            ourButton(
                              color: lightGolden,
                              title: signup,
                              textColor: redColor,
                              onPress: () {
                                Get.to(() => const SignupScreen());
                              },
                            ).box.width(context.screenWidth - 50).make(),
                          ],
                        ).box.white.rounded
                        .padding(const EdgeInsets.all(16))
                        .width(context.screenWidth - 70)
                        .shadowSm
                        .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
