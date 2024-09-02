import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_control/data/network/firebase/firebase_services.dart';

class SignUpOptions extends StatelessWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () async {
              FirebaseService.signInwWithGoogle();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color.fromRGBO(0, 204, 102, 1),
                    width: 1.0,
                  )),
              child: const Row(
                children: [
                  Spacer(),
                  Icon(
                    FontAwesomeIcons.google,
                    size: 18,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    "login with Google",
                  ),
                  Spacer(),
                ],
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        // GestureDetector(
        //     onTap: () {
        //       FirebaseService.signInWithApple();
        //     },
        //     child: Container(
        //       height: MediaQuery.of(context).size.height * 0.07,
        //       width: double.infinity,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(16),
        //           border: Border.all(
        //             color: const Color.fromRGBO(0, 204, 102, 1),
        //             width: 1.0,
        //           )),
        //       child: const Row(
        //         children: [
        //           // const SizedBox(width: 40,),
        //           Spacer(),
        //           // const SizedBox(width: 128),
        //           Icon(
        //             Icons.apple_rounded,
        //             color: Colors.white,
        //           ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           Text(
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               fontSize: 16,
        //               color: Colors.white,
        //               fontWeight: FontWeight.w500,
        //             ),
        //             "Register with Appe",
        //           ),
        //           Spacer(),
        //         ],
        //       ),
        //     )),
        // GestureDetector(
        //   onTap: () => FirebaseService.signInwWithGoogle(),
        //   child: const IconContainer(
        //       widget: Icon(
        //     FontAwesomeIcons.google,
        //     size: 18,
        //     color: Colors.white,
        //   )),
        // ),
        // const IconContainer(
        //     widget: Icon(
        //   Icons.apple_rounded,
        //   color: Colors.white,
        // )),
      ],
    );
  }
}
