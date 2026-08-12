// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/widgets_common/applogo_widget.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/custom_textfield.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();

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
              "Sign Up to $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            customTextField(
                              hint: nameHint,
                              title: name,
                              controller: nameController,
                              isPass: false,
                            ),
                            customTextField(
                              hint: emailHint,
                              title: email,
                              controller: emailController,
                              isPass: false,
                            ),
                            customTextField(
                              hint: passwordHint,
                              title: password,
                              controller: passwordController,
                              isPass: true,
                            ),
                            customTextField(
                              hint: passwordHint,
                              title: retypePassword,
                              controller: retypePasswordController,
                              isPass: true,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isCheck,
                                  checkColor: redColor,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isCheck = newValue ?? false;
                                    });
                                  },
                                ),
                                10.widthBox,
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "I agree to the",
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: fontGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: termAndCond,
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: redColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "&",
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: fontGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: privacyPolicy,
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).onTap(() => _showLegalInfo(context)),
                                ),
                              ],
                            ),
                            5.heightBox,
                            controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      redColor,
                                    ),
                                  )
                                : ourButton(
                                    color: isCheck == true
                                        ? redColor
                                        : lightGrey,
                                    title: signup,
                                    textColor: whiteColor,
                                    onPress: () async {
                                      final name = nameController.text.trim();
                                      final email = emailController.text.trim();
                                      final password = passwordController.text;
                                      if (!isCheck) {
                                        VxToast.show(
                                          context,
                                          msg:
                                              'Please accept the terms to continue',
                                        );
                                        return;
                                      }
                                      if (name.isEmpty ||
                                          email.isEmpty ||
                                          password.isEmpty) {
                                        VxToast.show(
                                          context,
                                          msg: 'Please complete all fields',
                                        );
                                        return;
                                      }
                                      if (password !=
                                          retypePasswordController.text) {
                                        VxToast.show(
                                          context,
                                          msg: 'Passwords do not match',
                                        );
                                        return;
                                      }
                                      if (password.length < 6) {
                                        VxToast.show(
                                          context,
                                          msg:
                                              'Password must be at least 6 characters',
                                        );
                                        return;
                                      }
                                      {
                                        controller.isLoading(true);
                                        try {
                                          final credential = await controller
                                              .signupMethod(
                                                context: context,
                                                email: email,
                                                password: password,
                                              );
                                          final user = credential?.user;
                                          if (user == null) return;
                                          await controller.storeUserData(
                                            user: user,
                                            email: email,
                                            name: name,
                                          );
                                          VxToast.show(context, msg: loggedin);
                                          Get.offAll(() => const Home());
                                        } catch (e) {
                                          auth.signOut();
                                          VxToast.show(
                                            context,
                                            msg: e.toString(),
                                          );
                                        } finally {
                                          controller.isLoading(false);
                                        }
                                      }
                                    },
                                  ).box.width(context.screenWidth - 50).make(),
                            10.heightBox,
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: alreadyHaveAccount,
                                    style: TextStyle(
                                      fontFamily: bold,
                                      color: fontGrey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: login,
                                    style: TextStyle(
                                      fontFamily: bold,
                                      color: redColor,
                                    ),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              Get.back();
                            }),
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

  void _showLegalInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Privacy'),
        content: const Text(
          'We use your account information to provide shopping, orders, messages, and profile features. '
          'You are responsible for accurate account and delivery information. Your password is managed securely by Firebase Authentication and is not stored in the app database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
