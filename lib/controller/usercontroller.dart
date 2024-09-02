import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_control/data/network/firebase/firebase_services.dart';
import 'package:task_control/data/shared%20pref/shared_pref.dart';
import 'package:task_control/screens/widgets/dialogs.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxString name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    var userData = await UserPref.getUser();
    getName(userData);
  }

  void getName(Map<dynamic, dynamic> userData) {
    name.value = userData['NAME'].toString(); // Get the full name
  }

  Future<void> updateName(String newName) async {
    if (newName.isNotEmpty) {
      await FirebaseService.updateUserName(newName); // Update in Firebase
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('NAME', newName);
      getUserData(); // Refresh user data after update
    } else {
      Get.snackbar('Error', 'Name cannot be empty');
    }
  }

  void showChangeNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    Get.dialog(namedialog(
        context: context,
        controller: nameController,
        // tess: name.string,
        buttononPressed: () {
          String newName = nameController.text;
          updateName(newName);
          Get.back();
        }));
  }

  Future<String> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Reauthenticate the user.
      AuthCredential credential = EmailAuthProvider.credential(
        email: "tim@gmail.com",
        password: "123456789",
      );
      await user!.reauthenticateWithCredential(credential);

      // If reauthentication is successful, change the password.
      await user.updatePassword("987654321");

      // Password changed successfully.
      return 'Password changed successfully.';
    } catch (e) {
      // Handle reauthentication errors and password change errors.
      return 'Error changing password: $e';
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'Password reset email sent.';
    } catch (e) {
      return 'Error sending password reset email: ${e.toString()}';
    }
  }
}
