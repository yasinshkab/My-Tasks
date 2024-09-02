import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/edit_task_controller.dart';
import 'package:task_control/controller/home_controller.dart';
import 'package:task_control/data/network/firebase/firebase_services.dart';
import 'package:task_control/model/task_model.dart';
import 'package:task_control/data/NotificationPlugin.dart';
import 'package:task_control/screens/auth/components/button.dart';
import 'package:task_control/screens/widgets/add_fild.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/screens/widgets/datetime_row.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:task_control/screens/widgets/periority_container.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, required this.taskKey});
  final String taskKey;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  EditTaskController controller = Get.put(EditTaskController());
  final homecontroller = Get.put(HomeController());

  DateTime? startDate;
  DateTime? endDate;
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    loadTaskData();
  }

  loadTaskData() async {
    TaskModel? task = await homecontroller.db.getTaskByKey(widget.taskKey);

    if (task != null) {
      setState(() {
        controller.title =
            Rx<TextEditingController>(TextEditingController(text: task.title));
        controller.description = Rx<TextEditingController>(
            TextEditingController(text: task.description));

        controller.key.value = task.key!;
        print(task.key);

        controller.category.value = task.category!;
        print(task.date);
        controller.date.value = task.date!;
        controller.time.value = task.time!;

        print("{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}");

        print(controller.date.value);

        if (task.periority == 'High') {
          controller.lowPeriority.value =
              true; // Assuming lowPeriority is an RxBool
        } else {
          controller.lowPeriority.value = false;
        }
        if (task.notification == 'enabaled') {
          controller.notification.value =
              true; // Assuming lowPeriority is an RxBool
        } else {
          controller.notification.value = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                // const SizedBox(
                //   width: 16,
                // ),
                const Spacer(),
                const Text(
                  'Edit Task',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 24),
                ),
                const Spacer(),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // TitlePeriority(),

            // const SizedBox(
            //   height: 20,
            // ),

            const SizedBox(
              height: 10,
            ),
            const Text(
              'Title',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => AddInputField(
                controller: controller.title.value,
                focus: controller.titleFocus.value,
                onTap: () => controller.setTitleFocus(),
                onTapOutSide: () => controller.onTapOutside(),
                hint: 'Enter task title',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            const Text(
              'Description',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => AddInputField(
                maxlines: 5,
                // contentpadding: const EdgeInsets.fromLTRB(10, 0, 10, 80),
                controller: controller.description.value,
                focus: controller.descriptionFocus.value,
                onTap: () => controller.setDescriptionFocus(),
                onTapOutSide: () => controller.onTapOutside(),
                hint: 'Enter description of your task (optional)',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Periority',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => PeriorityContainer(
                          onTap: () => controller.setPeriority(true),
                          focus: controller.lowPeriority.value,
                          type: "Low"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Obx(() => PeriorityContainer(
                        onTap: () => controller.setPeriority(false),
                        focus: !controller.lowPeriority.value,
                        type: "High")),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // DateTimeRow(),
            const Text(
              'Date and Time',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => DateTimeContainer(
                      text: controller.date.value.isEmpty
                          ? 'dd/mm/yyyy'
                          : controller.date.value,
                      icon: const Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.white24,
                        size: 20,
                      ),
                      onTap: () {
                        controller.pickDate(context);
                      },
                    )),
                Obx(() => DateTimeContainer(
                      text: controller.time.value.isEmpty
                          ? 'hh/mm'
                          : controller.time.value,
                      icon: const Icon(
                        Icons.watch,
                        color: Colors.white24,
                        size: 20,
                      ),
                      onTap: () {
                        controller.pickTime(context);
                        print(controller.pickedTime);
                      },
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Get alert for this task",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Obx(
                  () => CupertinoSwitch(
                    activeColor: const Color.fromRGBO(0, 204, 102, 1),
                    value: controller.notification
                        .value, // Bind the switch to the controller's variable
                    onChanged: (bool value) {
                      controller.notification.value =
                          value; // Update the controller's variable when the switch is changed
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              // width: 500,
              child: Row(
                children: [
                  EditButton(
                    text: 'Edit Task',
                    loading: false,
                    onTap: () async {
                      controller.updatedata(context);
                      if (controller.notification.value == true) {
                        // Combine selected date and time
                        DateTime dateTime = DateTime(
                          controller.theselectedDate.year,
                          controller.theselectedDate.month,
                          controller.theselectedDate.day,
                          controller.pickedTime.hour,
                          controller.pickedTime.minute,
                        );

                        // Check if the dateTime is in the future
                        if (dateTime.isBefore(DateTime.now())) {
                          print("Error: Scheduled time must be in the future.");
                          return;
                        }

                        // Convert to tz.TZDateTime
                        tz.TZDateTime scheduledDateTime =
                            tz.TZDateTime.from(dateTime, tz.local)
                                .add(Duration(seconds: 30));

                        await notificationPlugin.scheduleddNotification(
                            scheduledDateTime, controller.title.value.text);
                      } else {
                        await flutterLocalNotificationsPlugin.cancel(2);
                      }
                    },
                    // controller.showProgressPicker(context);
                  ),
                  Spacer(),
                  DeleteButton(
                    text: 'delete Task',
                    loading: false,
                    onTap: () async {
                      controller.deleteDataInDatabase();
                      // controller.showProgressPicker(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
