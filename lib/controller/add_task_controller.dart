import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_control/controller/DbHelper/db_helper.dart';
import 'package:task_control/controller/home_controller.dart';
import 'package:task_control/model/task_model.dart';
import 'package:task_control/data/utils.dart';

class AddTaskController extends GetxController {
  TimeOfDay pickedTime = TimeOfDay.now();
  DateTime theselectedDate = DateTime.now();
  var isSwitchOn = false.obs;
  final DbHelper database = DbHelper();
  final controller = Get.put(HomeController());
  RxBool lowPeriority = true.obs;
  RxBool taskstatus = true.obs;

  RxBool titleFocus = false.obs;
  // RxBool categoryFocus = false.obs;
  RxBool descriptionFocus = false.obs;
  RxBool loading = false.obs;
  RxBool notification = false.obs;
  Rx<TextEditingController> title = TextEditingController().obs;
  Rx<TextEditingController> description = TextEditingController().obs;
  // Rx<TextEditingController> category = TextEditingController().obs;
  RxString time = ''.obs;
  RxString category = ''.obs;
  RxString key = ''.obs;
  RxString date = ''.obs;

  insertDataInDatabase() async {
    try {
      loading.value = true;
      await database
          .insert(TaskModel(
              notification: notification.value ? 'enabaled' : 'disabled',
              status: taskstatus.value ? 'unComplete' : 'Complete',
              key: DateTime.now().microsecondsSinceEpoch.toString(),
              time: time.value,
              date: date.value,
              periority: lowPeriority.value ? 'High' : 'Low',
              description: description.value.text.toString(),
              category: category.value,
              title: title.value.text.toString(),
              email: controller.theemail.value.toString(),
              show: 'yes'))
          .then((value) async {
        controller.getTaskData();
        title.value.clear();
        // category.value.clear();
        date.value = '';
        category.value = '';

        date.value = '';
        time.value = '';
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

  showProgressPicker(BuildContext context) {
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
    insertDataInDatabase();
  }

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

  setTitleFocus() {
    titleFocus.value = true;
    descriptionFocus.value = false;
  }

  setDescriptionFocus() {
    titleFocus.value = false;
    descriptionFocus.value = true;
  }

  setPeriority(bool value) {
    lowPeriority.value = value;
  }

  onTapOutside() {
    titleFocus.value = false;
    descriptionFocus.value = false;
  }

  void clearTextFields() {
    title.value.clear();
    description.value.clear();
  }

  @override
  void onClose() {
    // Dispose the controllers when not in use

    clearTextFields();
    super.onClose();
  }
}
