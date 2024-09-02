import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/signin_controller.dart';
import 'package:task_control/screens/auth/components/button.dart';
import 'package:task_control/screens/auth/components/signin_input_form.dart';
import 'package:task_control/screens/auth/components/signup_options.dart';
import 'package:task_control/screens/auth/enter_email.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class SignInBody extends StatelessWidget {
  SignInBody({super.key});
  final controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Sign in',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
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
            SignInForm(),
            Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.to(EnterEmail()),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: '  Did you forget your password?  Reset password',
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    // TextSpan(
                    //     text: 're',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //     ))
                  ])),
                )),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () => AccountButton(
                text: "Login Account",
                loading: controller.loading.value,
                onTap: () {
                  // Get.to(HomePage());

                  controller.loginAccount();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color.fromARGB(255, 173, 173, 173),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "or",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(125, 125, 125, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color.fromARGB(255, 173, 173, 173),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SignUpOptions(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Get.to(const SignUp()),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ])),
                ))
          ],
        ),
      ),
    );
  }
}
