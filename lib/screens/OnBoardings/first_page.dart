import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_control/screens/auth/sign_in.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/data/services.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 250, 250, 250),
    ));
    super.initState();
  }

  ///يغير لون الشريط متع البطارية
  var boardingController = PageController();
  String a = "استمر";
  MyServices myServices = Get.find();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              "Welcome to MyTasks",
              style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 45,
            ),
            const Text(
              "Please login to your account or create new account to continue",
              style: TextStyle(fontSize: 12, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 45,
            ),

            //controller///////////////////////////
            const Spacer(),
            GestureDetector(
                onTap: () {
                  Get.to(const SignIn());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: 300,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 204, 102, 1),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Row(
                    children: [
                      // const SizedBox(width: 40,),
                      // const SizedBox(width: 128),
                      Spacer(),

                      Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                        "LOGIN",
                      ),
                      Spacer(),

                      // const Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.white,
                      //   size: 32,
                      // ),
                      // const SizedBox(width: 20,)
                    ],
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  Get.to(const SignUp());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(0, 204, 102, 1),
                        width: 1.0,
                      )),
                  child: const Row(
                    children: [
                      // const SizedBox(width: 40,),
                      Spacer(),
                      // const SizedBox(width: 128),
                      Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        "CREATE ACCOUNT",
                      ),
                      Spacer(),
                    ],
                  ),
                )),

            const SizedBox(
              height: 80,
            ),
          ]),
        ),
      ),
    );
  }
}
