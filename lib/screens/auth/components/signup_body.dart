import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/signup_controller.dart';
import 'package:task_control/screens/auth/components/signup_options.dart';
import 'package:task_control/screens/auth/sign_in.dart';

import 'button.dart';
import 'input_form.dart';

class SignupBody extends StatelessWidget {
  SignupBody({super.key});

  final controller = Get.put(SignupController());

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
                  'Sign up',
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
            //   'Sign up with one of the following options.',
            //   style: TextStyle(color: Colors.grey),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            InputForm(),
            Obx(
              () => AccountButton(
                text: "Create Account",
                loading: controller.loading.value,
                onTap: () {
                  controller.createAccount();
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
            // Spacer(),
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Get.to(const SignIn()),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ])),
                )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
