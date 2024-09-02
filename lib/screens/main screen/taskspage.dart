import 'package:animations/animations.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_control/controller/home_controller.dart';
import 'package:task_control/data/utils.dart';
import 'package:task_control/model/category_swtich.dart';
import 'package:task_control/screens/edittask.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(HomeController());
  DateTime _selectedDate = DateTime.now();
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Duration of the fade-in effect
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
          ),
          const Text(
            'Upcoming Tasks',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _animation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today Tasks',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          Utils.formatDate(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DatePicker(
              height: 100,
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: const Color.fromRGBO(0, 204, 102, 1),
              selectedTextColor: Colors.white,
              monthTextStyle: const TextStyle(color: textgrey),
              dateTextStyle: const TextStyle(
                  color: textgrey, fontWeight: FontWeight.bold, fontSize: 16),
              dayTextStyle: const TextStyle(color: textgrey),
              onDateChange: (date) {
                // New date selected
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.list.length,
                  itemBuilder: (context, index) {
                    // Parsing the date from the database
                    String dateFromDatabase =
                        controller.list[index].date; // '21 Jul 2024'
                    DateTime parsedDate =
                        DateFormat('dd MMM yyyy').parse(dateFromDatabase);

                    // Formatting the parsed date to 'MM/dd/yyyy'
                    String formattedDateFromDatabase =
                        DateFormat('MM/dd/yyyy').format(parsedDate);
                    if (controller.list[index].show == 'yes' &&
                        formattedDateFromDatabase ==
                            DateFormat('MM/dd/yyyy').format(_selectedDate)) {
                      categoriess(controller.list[index].category);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OpenContainer(
                          transitionDuration: const Duration(milliseconds: 500),
                          closedElevation: 0,
                          closedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          closedColor: const Color(0xff1F1F1F),
                          openBuilder: (context, _) => EditTaskPage(
                            taskKey: controller.list[index].key,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 110,
                                    width: 12,
                                    decoration: BoxDecoration(
                                      color: controller.list[index].periority ==
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
                                            controller.list[index].title,
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
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
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
                                              controller.list[index].category ==
                                                      ''
                                                  ? 'other'
                                                  : controller
                                                      .list[index].category,
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
                                        controller.list[index].status =
                                            controller.list[index].status ==
                                                    'Complete'
                                                ? 'unComplete'
                                                : 'Complete';
                                      });

                                      String newStatus =
                                          controller.list[index].status;
                                      await controller.statusupdate(
                                          controller.list[index].key,
                                          newStatus);
                                    },
                                    child: Container(
                                      width: 32.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        color: controller.list[index].status ==
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
                                        child: controller.list[index].status ==
                                                "Complete"
                                            ? const Icon(
                                                Icons.check,
                                                size: 16.0,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.check_box_outline_blank,
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
                      return SizedBox();
                    }
                  },
                )),
          ),
        ],
      ),
    ));
  }
}
