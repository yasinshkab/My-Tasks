import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_control/data/shared%20pref/shared_pref.dart';

class ProfileController extends GetxController {
  Rx<XFile?> image = Rx<XFile?>(null);
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxString name = ''.obs;
  Future<void> getUserData() async {
    var userData = await UserPref.getUser();
    getName(userData);
  }

  void getName(Map<dynamic, dynamic> userData) {
    name.value = userData['NAME'].toString(); // Get the full name
  }

  RxInt currantIndex = 0.obs;
  List titleList = [
    'Change app language'.tr,
    'Change account name'.tr,
    'Change account password'.tr,
    'Change account Image'.tr,
    // 'Add Category'.tr,
    'About US'.tr,
  ];
  RxList itemList = [
    Icons.language,
    Icons.person_2_outlined,
    Icons.key_outlined,
    Icons.camera_alt_outlined,
    // Icons.category_outlined,
    Icons.info_outline_rounded
  ].obs;

  Future<void> updateUsername(context) async {
    var user = auth.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(name.value);
        await user.reload();
        user = auth.currentUser;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update username: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is signed in')),
      );
    }
  }
}
