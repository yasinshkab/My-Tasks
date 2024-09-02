import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_control/controller/DbHelper/db_helper.dart';
import 'package:task_control/data/notification_services.dart';
import 'package:task_control/data/services.dart';
import 'package:task_control/screens/category.dart';
import 'package:task_control/screens/main%20screen/notespage.dart';
import 'package:task_control/screens/main%20screen/profilepage.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/screens/taskpage.dart';
import 'package:task_control/screens/main%20screen/taskspage.dart';
import 'package:task_control/screens/notepage.dart';
import 'dart:io';

import 'package:task_control/screens/main%20screen/home_page.dart';

// nav bar
class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    const TheHomePage(),
    const TasksPage(),
    NotesPage(),
    const ProfileScreen(),
  ];
  var notifyHelper;

  final List listOfIcons = [
    Icons.home_rounded,
    Icons.checklist,
    Icons.edit_note,
    Icons.person_rounded,
  ];

  final RxInt currentIndex = 0.obs;
  @override
  void initState() {
    super.initState();

    // DeviceInfo deviceInfo = DeviceInfo();
    // deviceInfo.getDeviceName().then((value) {
    //   setState(() {
    //     deviceName = value;
    //   });
    // });

    NotifyHelper().initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    DbHelper db = DbHelper();
    db.printAllTasks();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        spacing: 10,
        overlayColor: Colors.black,
        icon: Icons.add,
        backgroundColor: const Color.fromRGBO(0, 204, 102, 1),
        buttonSize: const Size(68, 68), // Size of the main button
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12.0)), // Squared button with rounded corners
        childrenButtonSize:
            const Size(100.0, 78.0), // Size of the child buttons
        children: [
          SpeedDialChild(
            backgroundColor: primaryColor,
            child: Container(
              width: 120.0,
              height: 54.0,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                  child: Text("task",
                      style: TextStyle(fontSize: 24.0, color: Colors.white))),
            ),
            onTap: () {
              // Assuming you have an instance of FlutterLocalNotificationsPlugin

              Get.to(
                () => const TaskPage(),
                transition:
                    Transition.fadeIn, // Add your desired transition here
                duration:
                    const Duration(milliseconds: 750), // Adjust the duration
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: primaryColor,
            child: Container(
              width: 120.0, // Width of the child button
              height: 54.0, // Height of the child button
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Center(
                  child: Text("note",
                      style: TextStyle(fontSize: 24.0, color: Colors.white))),
            ),
            onTap: () {
              Get.to(
                () => const TextToSpeechScreen(),
                transition:
                    Transition.fadeIn, // Add your desired transition here
                duration:
                    const Duration(milliseconds: 750), // Adjust the duration
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(width: size.width * 0.1), // Left padding
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: size.width * 0.01),
                  buildNavItem(0, size),
                  // Space between first and second icon
                  buildNavItem(1, size),
                  SizedBox(
                      width: size.width *
                          0.1), // Space between second and third icon
                  buildNavItem(2, size),
                  // Space between third and fourth icon
                  buildNavItem(3, size),
                  SizedBox(width: size.width * 0.01),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: Obx(() => pages[currentIndex.value])),
    );
  }

  Widget buildNavItem(int index, Size size) {
    return Obx(
      () => InkWell(
        onTap: () {
          currentIndex.value = index;
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastLinearToSlowEaseIn,
              margin: EdgeInsets.only(
                bottom: index == currentIndex.value ? 0 : size.width * .029,
                right: size.width * .0422,
                left: size.width * .0422,
              ),
              width: size.width * .128,
              height: index == currentIndex.value ? size.width * .014 : 0,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 204, 102, 1),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
            ),
            Icon(
              listOfIcons[index],
              size: size.width * .076,
              color: index == currentIndex.value
                  ? const Color.fromRGBO(0, 204, 102, 1)
                  : Colors.white70,
            ),
            SizedBox(height: size.width * .03),
          ],
        ),
      ),
    );
  }
}

final ImagePicker _picker = ImagePicker();

void showPicker(BuildContext context, Function(XFile?) onImagePicked) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: grey,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Change account name",
                    style: TextStyle(color: ligtstgrey, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 1.5,
                    color: ligtstgrey),
                const SizedBox(
                  height: 16,
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: const Text('Photo Library',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    onImagePicked(pickedFile);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.white),
                  title: const Text('Camera',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    onImagePicked(pickedFile);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ProfileScreenki extends StatefulWidget {
  const ProfileScreenki({super.key});

  @override
  State<ProfileScreenki> createState() => _ProfileScreenkiState();
}

class _ProfileScreenkiState extends State<ProfileScreenki> {
  MyDrawerController drawerController = Get.put(MyDrawerController());
  // UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 1),
                  child: Row(
                    children: [
                      // Image.asset('assets/icons/profile/logo@2x.png', scale: 2),
                      SizedBox(width: 16),
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
                  child: Obx(() {
                    return CircleAvatar(
                      radius: 50,
                      child: drawerController.image.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                File(drawerController.image.value!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
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
                    );
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('the man',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
                Container(
                  child: ListView.builder(
                    itemCount: drawerController.itemList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var item = drawerController.itemList[index];
                      return ProfileMenu(
                        icon: item,
                        text: drawerController.titleList[index],
                        press: () {
                          drawerController.currantIndex.value = index;
                          drawerController.onTapSwitchCase(index, context);
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
                      TextButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            MyServices myServices = Get.find();
                            myServices.sharedPreferences.clear();
                            // Get.delete<LoginControllerImp>();

                            Future.delayed(const Duration(milliseconds: 1))
                                .then((value) => Get.toNamed("/login"));
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
                      ),
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

class MyDrawerController extends GetxController {
  Rx<XFile?> image = Rx<XFile?>(null);

  RxInt currantIndex = 0.obs;
  List titleList = [
    'Change app language'.tr,
    'Change account name'.tr,
    'Change account password'.tr,
    'Change account Image'.tr,
    'Add Category'.tr,
    'About US'.tr,
  ];
  RxList itemList = [
    Icons.language,
    Icons.person_2_outlined,
    Icons.key_outlined,
    Icons.camera_alt_outlined,
    Icons.category_outlined,
    Icons.info_outline_rounded
  ].obs;

  onTapSwitchCase(int index, BuildContext context) {
    switch (index) {
      case 0:
        print("1");
        break;
      case 1:
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => somedialog(
            context: context,
            button: false,
            buttononPressed: () {
              Get.back();
            },
            textbuttononPressed: () {
              Get.back();
            },
          ),
        );
        break;
      case 2:
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => passwordDialog(
            context: context,
            button: false,
            buttononPressed: () {
              Get.back();
            },
            textbuttononPressed: () {
              Get.back();
            },
          ),
        );
        break;
      case 3:
        showPicker(context, (pickedFile) {
          image.value = pickedFile;
        });
        break;
      case 4:
        Get.to(const AddCategories());
        break;
      case 5:
        print("5");
        break;
    }
  }
}

Widget somedialog(
        {required BuildContext context,
        required bool button,
        required void Function()? textbuttononPressed,
        required void Function()? buttononPressed}) =>
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

                const Text(
                  textAlign: TextAlign.center,
                  "Change account name",
                  style: TextStyle(color: ligtstgrey, fontSize: 18),
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
                  // controller: controller,
                  onTap: () {},
                  onTapOutside: (event) {
                    // _signUpController.onTapOutside(context);
                    // _signInController.onTapOutside(context);
                  },
                  onChanged: (value) {
                    // onChange();
                  },

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
                        horizontal: 30, vertical: 20),
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
                        onPressed: buttononPressed,
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
                    Container(
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
Widget passwordDialog(
        {required BuildContext context,
        required bool button,
        required void Function()? textbuttononPressed,
        required void Function()? buttononPressed}) =>
    Dialog(
      // shadowColor: grey,
      // backgroundColor: grey,
      // surfaceTintColor: grey,
      child:
          // ignore: sized_box_for_whitespace
          Container(
        decoration:
            BoxDecoration(color: grey, borderRadius: BorderRadius.circular(12)),
        height: MediaQuery.of(context).size.height * 0.42,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Change account Password",
                    style: TextStyle(color: ligtstgrey, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 1.5,
                    color: ligtstgrey),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Enter old password",
                  style: TextStyle(color: ligtstgrey, fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onTap: () {},
                  onTapOutside: (event) {},
                  onChanged: (value) {
                    // onChange();
                  },
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    filled: true,

                    fillColor: primaryColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    // hoverColor: Colors.pinkAccent,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Enter new password",
                  style: TextStyle(color: ligtstgrey, fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onTap: () {},
                  onTapOutside: (event) {
                    // _signUpController.onTapOutside(context);
                    // _signInController.onTapOutside(context);
                  },
                  onChanged: (value) {
                    // onChange();
                  },
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    filled: true,

                    fillColor: primaryColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    // hoverColor: Colors.pinkAccent,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
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
                        onPressed: buttononPressed,
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
                    Container(
                      height: 48,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6)),
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
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
