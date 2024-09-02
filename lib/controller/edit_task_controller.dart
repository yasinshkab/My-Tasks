import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_control/controller/DbHelper/db_helper.dart';
import 'package:task_control/controller/home_controller.dart';
import 'package:task_control/data/utils.dart';
import 'package:task_control/model/task_model.dart';

class EditTaskController extends GetxController {
  TimeOfDay pickedTime = TimeOfDay.now();
  DateTime theselectedDate = DateTime.now();
  RxBool lowPeriority = true.obs;
  RxBool taskstatus = true.obs;
  DateTime dateTime = DateTime.now();
  RxBool titleFocus = false.obs;
  RxBool descriptionFocus = false.obs;
  RxBool loading = false.obs;
  RxDouble progress = 0.0.obs;
  Rx<TextEditingController> title = TextEditingController().obs;
  Rx<TextEditingController> description = TextEditingController().obs;
  final DbHelper database = DbHelper();
  final controller = Get.put(HomeController());
  // Ensure correct initialization
  RxString key = ''.obs;

  // Rx<TextEditingController> category = TextEditingController().obs;
  RxString time = ''.obs;
  RxString category = ''.obs;

  RxString date = ''.obs;
  // Constructor

  RxBool notification = false.obs;
  // Observable properties
  var taskData = ''.obs;
  Future<void> pickDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      theselectedDate = pickedDate;
      date.value = Utils.formateDate(pickedDate);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final now = DateTime.now();
    final newTime = now.add(const Duration(minutes: 1));
    final initialTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: TimePickerThemeData(
              dialBackgroundColor: Colors.grey,
              dayPeriodColor: const Color.fromRGBO(0, 204, 102, 1),
              backgroundColor: Colors.grey[900],
              hourMinuteTextColor: Colors.white,
              dayPeriodTextColor: Colors.white,
              dialHandColor: Colors.white,
              dialTextColor: Colors.white,
              entryModeIconColor: Colors.white,
            ),
            colorScheme: ColorScheme.dark(
              primary: const Color.fromRGBO(0, 204, 102, 1),
              onPrimary: Colors.white,
              surface: Colors.grey[800]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Combine picked time with the selected date
      DateTime now = DateTime.now();
      DateTime combinedDateTime = DateTime(
        theselectedDate.year,
        theselectedDate.month,
        theselectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Ensure that the selected time is not before the current time
      if (combinedDateTime.isBefore(now)) {
        // Optionally: Show an alert or reset the time
        print("The selected time is in the past. Please choose a future time.");
        return;
      }

      time.value = DateFormat('hh:mm a').format(combinedDateTime);
      this.pickedTime = pickedTime;
    }
  }

  setPeriority(bool value) {
    lowPeriority.value = value;
  }

  onTapOutside() {
    titleFocus.value = false;
    descriptionFocus.value = false;
  }

  setTitleFocus() {
    titleFocus.value = true;
    descriptionFocus.value = false;
  }

  setDescriptionFocus() {
    titleFocus.value = false;
    descriptionFocus.value = true;
  }

  updatedata(
    BuildContext context,
  ) {
    if (title.value.text.toString().isEmpty) {
      Utils.showSnackBar(
          'Warning',
          'Add title of your task',
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pinkAccent,
          ));
      return;
    }
    if (date.value.isEmpty) {
      Utils.showSnackBar(
          'Warning',
          'Add date for your task',
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pinkAccent,
          ));
      return;
    }
    if (int.parse(Utils.getDaysDiffirece(date.value)) < 0) {
      Utils.showSnackBar(
          'Warning',
          'Please select correct date',
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pinkAccent,
          ));
      return;
    }
    // ProgressPicker(context);
    // Get.back();
    updateDataInDatabase();
  }

  updateDataInDatabase() async {
    print("Updating task data");
    print("Key: ${key.value}");
    print("Date: ${date.value}");
    print("Low Periority: ${lowPeriority.value}");
    print("Task Status: ${taskstatus.value}");
    print("Category: ${category.value}");
    print("Time: ${time.value}");
    print("Description: ${description.value.text}");
    print("Title: ${title.value.text}");
    print("(((((((((((((((((((())))))))))))))))))))");

    try {
      loading.value = true;
      await database
          .updateTask(TaskModel(
              notification: notification.value ? 'enabaled' : 'disabled',
              status: taskstatus.value ? 'unComplete' : 'Complete',
              key: key.value,
              time: time.value,
              date: date.value,
              periority: lowPeriority.value ? 'High' : 'Low',
              description: description.value.text.toString(),
              category: category.value,
              title: title.value.text.toString(),
              email: controller.theemail.value.toString(),
              // image: Utils.getImage()[selectedImageIndex.value],
              show: 'yes'))
          .then((value) async {
        await Future.delayed(const Duration(milliseconds: 700));
        controller.getTaskData();
        // title.value.clear();
        // category.value.clear();
        date.value = '';
        category.value = '';

        date.value = '';
        time.value = '';
        notification.value = false;
        await Future.delayed(const Duration(milliseconds: 700));
        loading.value = false;

        Get.back();
      }).onError((error, stackTrace) {
        loading.value = false;
      });
    } catch (e) {
      loading.value = false;
      Utils.showSnackBar(
          'Warning',
          e.toString(),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pinkAccent,
          ));
    }
  }

  deleteDataInDatabase() async {
    print("Updating task data");
    print("Key: ${key.value}");
    print("Date: ${date.value}");
    print("Low Periority: ${lowPeriority.value}");
    print("Task Status: ${taskstatus.value}");
    print("Category: ${category.value}");
    print("Time: ${time.value}");
    print("Description: ${description.value.text}");
    print("Title: ${title.value.text}");
    print("(((((((((((((((((((())))))))))))))))))))");

    try {
      loading.value = true;
      await database
          .updateTask(TaskModel(
              // progress: progress.value.toInt().toString(),
              notification: notification.value ? 'enabaled' : 'disabled',
              status: taskstatus.value ? 'unComplete' : 'Complete',
              key: key.value,
              time: time.value,
              date: date.value,
              periority: lowPeriority.value ? 'High' : 'Low',
              description: description.value.text.toString(),
              category: category.value,
              title: title.value.text.toString(),
              // image: Utils.getImage()[selectedImageIndex.value],
              email: controller.theemail.value.toString(),
              show: 'no'))
          .then((value) async {
        await Future.delayed(const Duration(milliseconds: 700));
        controller.getTaskData();
        // title.value.clear();
        // category.value.clear();
        date.value = '';
        category.value = '';

        date.value = '';
        time.value = '';
        notification.value = false;
// Ensure it resets correctly
        await Future.delayed(const Duration(milliseconds: 700));
        loading.value = false;

        Get.back();
      }).onError((error, stackTrace) {
        loading.value = false;
      });
    } catch (e) {
      loading.value = false;
      Utils.showSnackBar(
          'Warning',
          e.toString(),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pinkAccent,
          ));
    }
  }
}
