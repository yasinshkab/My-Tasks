import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/usercontroller.dart';
import 'package:task_control/screens/auth/sign_up.dart';

Future<void> showChangePasswordDialog(context, String email) async {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final controller = Get.put(UserController());

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to close the dialog.
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Change'),
            onPressed: () async {
              String currentPassword = currentPasswordController.text;
              String newPassword = newPasswordController.text;
              print("${currentPassword}/////////////////////${newPassword}");
              // Call your password update function here
              await controller.sendPasswordResetEmail(email);

              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

Widget namedialog({
  required BuildContext context,
  required TextEditingController controller,
  required void Function()? buttononPressed,
  // required String tess,
}) =>
    Dialog(
      // shadowColor: grey,
      // backgroundColor: grey,
      // surfaceTintColor: grey,
      child:
          // ignore: sized_box_for_whitespace
          Container(
        decoration:
            BoxDecoration(color: grey, borderRadius: BorderRadius.circular(12)),
        height: MediaQuery.of(context).size.height * 0.32,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),

                Text(
                  textAlign: TextAlign.center,
                  "Change The name ",
                  style: const TextStyle(color: ligtstgrey, fontSize: 18),
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 1.5,
                    color: ligtstgrey),
                const Spacer(),

                // Obx(
                //   () =>
                TextFormField(
                  controller: controller,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    filled: true,

                    fillColor: primaryColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    // hoverColor: Colors.pinkAccent,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 12),
                  ),
                ),
                // ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 32,
                      width: 80,
                      // decoration: BoxDecoration(
                      //     // color: const Color.fromRGBO(226, 33, 38, 1),
                      //     borderRadius: BorderRadius.circular(10)
                      //     ),
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () => Get.back(),
                        child: const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                          "Cancel",
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: Container(
                        height: 48,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: buttononPressed,
                          child: const Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            "Edit",
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );

Widget thedialog(
        {required BuildContext context,
        required bool button,
        required void Function()? textbuttononPressed,
        required void Function()? buttononPressed}) =>
    Dialog(
      // shadowColor: grey,
      // backgroundColor: grey,
      // surfaceTintColor: grey,
      child: Container(
        decoration:
            BoxDecoration(color: grey, borderRadius: BorderRadius.circular(10)),
        height: MediaQuery.of(context).size.height * 0.28,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Save changes ?",
                  style: TextStyle(color: ligtstgrey, fontSize: 18),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: buttononPressed,
                        child: const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          "Save",
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(226, 33, 38, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: buttononPressed,
                        child: const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          "Discard",
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
