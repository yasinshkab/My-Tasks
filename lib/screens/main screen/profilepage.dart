import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_control/controller/profile_controller.dart';
import 'package:task_control/controller/signup_controller.dart';
import 'package:task_control/controller/usercontroller.dart';
import 'package:task_control/data/services.dart';
import 'package:task_control/screens/aboutus.dart';
import 'package:task_control/screens/auth/sign_up.dart';

SignupController controller = Get.put(SignupController());
final FirebaseAuth auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());
  String? _imageBase64;
  UserController userController = Get.put(UserController());
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      File? compressedImage = await compressImage(imageFile);
      if (compressedImage != null) {
        String base64Image = base64Encode(compressedImage.readAsBytesSync());
        await saveImageToSharedPreferences(base64Image);
        _loadImage();
      }
    }
  }

  Future<File?> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 800,
      quality: 80,
    );
    if (result != null) {
      return File(file.path)..writeAsBytesSync(result);
    }
    return null;
  }

  Future<void> saveImageToSharedPreferences(String base64Image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', base64Image);
  }

  Future<String?> getImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_image');
  }

  @override
  void initState() {
    super.initState();

    _loadImage();
  }

  Future<void> _loadImage() async {
    String? imageBase64 = await getImageFromSharedPreferences();
    setState(() {
      _imageBase64 = imageBase64;
    });
  }

  onTapSwitchCase(int index, BuildContext context) {
    User user = auth.currentUser!;

    switch (index) {
      case 0:
        print("1");
        break;
      case 1:
        userController.showChangeNameDialog(context);
        // namedialog(
        //     context: context,
        //     controller: nameController,
        //     tess: userController.name.string,
        //     buttononPressed: () {
        //       String newName = nameController.text;
        //       userController.updateName(newName);
        //     });
        break;
      case 2:
        MyServices myServices = Get.find();
        // myServices.sharedPreferences.clear();
        // Get.delete<LoginControllerImp>();
        myServices.sharedPreferences.setString("step", "1");
        // showChangePasswordDialog(context,);
        userController.sendPasswordResetEmail(user.email!).then((value) =>
            Future.delayed(const Duration(milliseconds: 1))
                .then((value) => Get.offAndToNamed("/login")));

        break;
      case 3:
        // showPicker(context, (pickedFile) {
        //   image.value = pickedFile;
        // });
        pickImage();

        break;
      case 4:
        Get.to(
          () => const AboutUsPage(),
          transition:
              Transition.rightToLeft, // Add your desired transition here
          duration: const Duration(milliseconds: 750), // Adjust the duration
        );
        break;
    }
  }

  // UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 22,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      // Image.asset('assets/icons/profile/logo@2x.png', scale: 2),
                      // SizedBox(width: 16),
                      Expanded(
                        child: Text('Profile',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      // IconButton(
                      //   iconSize: 28,
                      //   icon: Image.asset(
                      //       'assets/icons/tabbar/light/more_circle@2x.png',
                      //       scale: 2),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Image.asset('images/logo-fixed 3 b.png', scale: 2),
                // ),
                Center(
                  child: ClipOval(
                    child: _imageBase64 != null
                        ? Image.memory(
                            base64Decode(_imageBase64!),
                            // width: 120,
                            fit: BoxFit.cover,
                            width: 100, // Adjust the width as needed
                            height: 100,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(' ${userController.name}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
                Container(
                  child: ListView.builder(
                    itemCount: profileController.itemList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var item = profileController.itemList[index];
                      return ProfileMenu(
                        icon: item,
                        text: profileController.titleList[index],
                        press: () {
                          profileController.currantIndex.value = index;
                          onTapSwitchCase(index, context);
                        },
                        //      isSelected: drawerController.currantIndex.value == index
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // TextButton(
                      //   onPressed: () {
                      //     // Add your onPressed code here!
                      //   },
                      //   style: TextButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 12),
                      //     textStyle: const TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      //   child:
                      GestureDetector(
                        onTap: () async {
                          MyServices myServices = Get.find();
                          // myServices.sharedPreferences.clear();
                          // Get.delete<LoginControllerImp>();
                          myServices.sharedPreferences.setString("step", "1");
                          Future.delayed(const Duration(milliseconds: 1))
                              .then((value) => Get.offAndToNamed("/login"));
                          auth.signOut();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                            ), // Replace with your desired icon
                            SizedBox(width: 8), // Space between icon and text
                            Text(
                              'Log out',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ), // Replace with your desired text
                          ],
                        ),
                      ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
          ),
        )
        // _buildOption(context, index, data);
        //   ],
        // ),
        );
  }

  // Widget _buildOption(BuildContext context, int index, ProfileOption data) {
  //   return ListTile(
  //     leading: Image.asset(data.icon, scale: 2),
  //     title: Text(
  //       data.title,
  //       style: TextStyle(
  //           fontWeight: FontWeight.w500, fontSize: 18, color: data.titleColor),
  //     ),
  //     trailing: data.trailing,
  //     onTap: () {},
  //   );
  // }
}

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: widget.press,
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon,
            //   color: Colors.black,
            //   width: 22,
            // ),
            Icon(
              widget.icon,
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Text(
              widget.text,
              style: const TextStyle(color: Colors.white),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
