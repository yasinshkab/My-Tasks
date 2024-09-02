import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/signin_controller.dart';
import 'package:task_control/screens/auth/components/button.dart';
import 'package:task_control/screens/auth/components/text_field.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/screens/widgets/back_button.dart';

// ignore: must_be_immutable
class EnterEmail extends StatelessWidget {
  final controller = Get.put(SignInController());
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'Password reset email sent.';
    } catch (e) {
      return 'Error sending password reset email: ${e.toString()}';
    }
  }

  EnterEmail({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          CustomBackButton(),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Enter Your Email',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Image(
                            height: MediaQuery.of(context).size.height * 0.46,
                            width: MediaQuery.of(context).size.width * 0.8,
                            image: const AssetImage(
                                "assets/images/Group 527.png")),
                      ),
                      // const SignInBar(),
                      // const SizedBox(
                      //   height: 50,
                      // ),
                      // const Text(
                      //   'Sign in with one of the following options.',
                      //   style: TextStyle(color: Colors.grey),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => InputField(
                            onTap: () => controller.onFocusEmail(),
                            focus: controller.emailFocus.value,
                            hint: "tim@gmail.com",
                            controller: controller.email.value,
                            correct: controller.correctEmail.value,
                            onChange: controller.validateEmail,
                          )),
                      const SizedBox(
                        height: 20,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => AccountButton(
                          text: "Send Email",
                          loading: controller.loading.value,
                          onTap: () async {
                            // Get.to(const OtpCode());
                            sendPasswordResetEmail(
                              controller.email.value.text,
                            ).then((value) => Future.delayed(
                                    const Duration(milliseconds: 1))
                                .then((value) => Get.offAndToNamed("/login")));
                            // controller.loginAccount();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]))),
      ),
    );
  }
}
