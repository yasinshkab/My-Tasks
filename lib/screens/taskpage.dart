import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/add_task_controller.dart';
import 'package:task_control/data/utils.dart';
import 'package:task_control/data/NotificationPlugin.dart';
import 'package:task_control/screens/auth/components/button.dart';
import 'package:task_control/screens/widgets/add_fild.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/screens/widgets/datetime_row.dart';
import 'package:task_control/screens/widgets/periority_container.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // controller.date.value = Utils.formateDate(selectedDate);
    controller.category.value = '';
    controller.title.value.clear();
    controller.description.value.clear();
    controller.date.value = Utils.formateDate(selectedDate);

    controller.time.value = '';
    print("{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}");

    print(controller.date.value);

    controller.lowPeriority.value = false;
    controller.notification.value = false;
  }

  final controller = Get.put(AddTaskController());

  DateTime selectedDate = DateTime.now();

  List<String> categories = [
    'Other',
    'Technology',
    'Health',
    'Finance',
    'Education',
    'Entertainment',
    'Sports',
    'Travel',
    'Food',
  ];

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
              height: 18,
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
                const Spacer(),
                const Text(
                  'Create new task',
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePicker(
                  height: 100,
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: const Color.fromRGBO(0, 204, 102, 1),
                  selectedTextColor: Colors.white,
                  monthTextStyle: const TextStyle(color: textgrey),
                  dateTextStyle: const TextStyle(
                      color: textgrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  dayTextStyle: const TextStyle(color: textgrey),
                  onDateChange: (date) {
                    setState(() {
                      selectedDate = date;
                      controller.date.value = Utils.formateDate(selectedDate);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Category',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          controller.category.value = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00CC66)
                              : const Color(0xFF444C4F),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
            const Text(
              'Time',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
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
            Obx(() => AccountButton(
                  text: 'Create Task',
                  loading: controller.loading.value,
                  onTap: () async {
                    // scheduleNotification(
                    //     DateTime.now().add(Duration(minutes: 1)));
                    controller.showProgressPicker(context);

                    if (controller.notification.value == true) {
                      // Combine selected date and time
                      DateTime dateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
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
                      print("u did not");
                    }
                  },
                )),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
