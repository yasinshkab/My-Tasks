import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_control/controller/home_controller.dart';
import 'package:task_control/model/category_swtich.dart';
import 'package:task_control/screens/edittask.dart';
import 'package:task_control/screens/main%20screen/mainscreen.dart';
import 'package:task_control/data/utils.dart';

class TheHomePage extends StatefulWidget {
  const TheHomePage({super.key});

  @override
  State<TheHomePage> createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHomePage> {
  final controller = Get.put(HomeController());

  MyDrawerController drawerController = Get.put(MyDrawerController());
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _loadImage();
    controller.getUserData();
  }

  Future<String?> getImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_image');
  }

  Future<void> _loadImage() async {
    String? imageBase64 = await getImageFromSharedPreferences();
    setState(() {
      _imageBase64 = imageBase64;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipOval(
                    child: _imageBase64 != null
                        ? Image.memory(
                            base64Decode(_imageBase64!),
                            // width: 120,
                            fit: BoxFit.cover,
                            width: 80, // Adjust the width as needed
                            height: 80,
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
                  Column(
                    children: [
                      Obx(
                        () => Text(
                          'Hi, ${controller.name}',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                      Text(
                        Utils.formatDate(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Obx(
                () => controller.dlist.isNotEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        height: 160,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    24.0), // Adjust the radius as needed
                                image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/Group 528.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Daily Task",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${controller.completedTasksCount}/${controller.totalTasksCount} Task Completed",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Obx(
                                        () => controller.completedTasksCount ==
                                                controller.totalTasksCount
                                            ? const Text(
                                                "Good Jop.You All of our Tasks",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : const Text(
                                                "You are almost done go ahead",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 100,
                                    child: CircularPercentIndicator(
                                      arcType: ArcType.FULL,
                                      arcBackgroundColor:
                                          const Color.fromRGBO(0, 153, 76, 1),
                                      animationDuration: 800,
                                      radius: 50.0,
                                      lineWidth: 12.0,
                                      animation: true,
                                      percent: controller.completedPercentage,
                                      center: Text(
                                        "${(controller.completedPercentage * 100).toInt()} %",
                                        style: const TextStyle(
                                          fontFamily: 'alamari',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Image.asset(
                                  "assets/images/Checklist-rafiki 1.png"),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Add Tasks to see them here",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Tap + to add your Projects and Tasks",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ]),
                      ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => controller.dlist.isNotEmpty
                    ? const Text(
                        'Today’s Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      )
                    : const SizedBox(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(6.0),
                child: Obx(() => ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.dlist.length,
                      itemBuilder: (context, index) {
                        if (controller.dlist.isNotEmpty) {
                          categoriess(controller.dlist[index].category);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OpenContainer(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              closedElevation: 0,
                              closedShape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                              ),
                              closedColor: const Color(0xff1F1F1F),
                              openBuilder: (context, _) => EditTaskPage(
                                taskKey: controller.dlist[index].key,
                              ),
                              closedBuilder: (context, openContainer) =>
                                  GestureDetector(
                                onTap: openContainer,
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff1F1F1F),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 110,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          color: controller
                                                      .dlist[index].periority ==
                                                  "Low"
                                              ? const Color.fromRGBO(
                                                  205, 102, 102, 1)
                                              : const Color.fromRGBO(
                                                  255, 217, 102, 1),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            SizedBox(
                                              width: 240,
                                              child: Text(
                                                controller.dlist[index].title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: catcolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        4, 1.75, 4, 1.75),
                                                    child: Row(
                                                      children: [
                                                        Icon(caticon,
                                                            color: iconcolor),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  controller.dlist[index]
                                                              .category ==
                                                          ''
                                                      ? 'other'
                                                      : controller.dlist[index]
                                                          .category,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            controller.dlist[index].status =
                                                controller.dlist[index]
                                                            .status ==
                                                        'Complete'
                                                    ? 'unComplete'
                                                    : 'Complete';
                                          });

                                          String newStatus =
                                              controller.dlist[index].status;
                                          await controller.statusupdate(
                                              controller.dlist[index].key,
                                              newStatus);
                                        },
                                        child: Container(
                                          width: 32.0,
                                          height: 32.0,
                                          decoration: BoxDecoration(
                                            color: controller
                                                        .dlist[index].status ==
                                                    "Complete"
                                                ? Colors.green
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.green,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Center(
                                            child: controller
                                                        .dlist[index].status ==
                                                    "Complete"
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 16.0,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16.0,
                                                    color: Colors.transparent,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
