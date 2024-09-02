import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_control/controller/DbHelper/db_helper.dart';
import 'package:task_control/data/network/firebase/firebase_services.dart';
import 'package:task_control/data/shared%20pref/shared_pref.dart';
import 'package:task_control/model/task_model.dart';
import 'package:task_control/data/utils.dart';

class HomeController extends GetxController {
  RxMap userData = {}.obs;
  RxString name = ''.obs;
  RxString theemail = ''.obs;

  RxBool focus = false.obs;
  RxBool hasText = false.obs;
  RxInt taskCount = 0.obs;
  RxBool hasData = false.obs;
  final DbHelper db = DbHelper();

  RxBool taskstatus = true.obs;
  DateTime selectedDate = DateTime.now(); // Your selected date here
  RxList list = [].obs;
  RxList dlist = [].obs;

  Connectivity? connectivity;
  final searchController = TextEditingController().obs;
  HomeController() {
    // if name not loaded
    if (userData['NAME'] == null) {
      getUserData();
    }
    // check for set listeners only for one time
    if (connectivity == null) {
      String str = FirebaseService.auth.currentUser!.email.toString();
      String node = str.substring(0, str.indexOf('@'));
      // listener for changing live database
      FirebaseDatabase.instance
          .ref('Tasks')
          .child(node)
          .onValue
          .listen((event) async {
        // int count = await FirebaseService.childCount();
        // check if live database has more child than local

        getTaskData();
        for (var element in event.snapshot.children) {
          if (!await db.isRowExists(
              element.child('key').value.toString(), 'Tasks')) {
            db
                .insert(
              TaskModel(
                  key: element.child('key').value.toString(),
                  time: element.child('time').value.toString(),
                  notification: element.child('notification').value.toString(),
                  status: element.child('status').value.toString(),
                  date: element.child('date').value.toString(),
                  periority: element.child('periority').value.toString(),
                  description: element.child('description').value.toString(),
                  category: element.child('category').value.toString(),
                  title: element.child('title').value.toString(),
                  email: element.child('email').value.toString(),
                  show: element.child('show').value.toString()),
            )
                .then((value) {
              getTaskData();
            });
          }
        }
      });

      FirebaseDatabase.instance
          .ref('Tasks')
          .child(node)
          .onChildChanged
          .listen((event) async {
        // int count = await FirebaseService.childCount();

        // check if live database has more child than local
        getTaskData();
        for (var element in event.snapshot.children) {
          db
              .update(TaskModel(
                  notification: element.child('notification').value.toString(),
                  status: element.child('status').value.toString(),
                  key: element.child('key').value.toString(),
                  time: element.child('time').value.toString(),
                  date: element.child('date').value.toString(),
                  periority: element.child('periority').value.toString(),
                  description: element.child('description').value.toString(),
                  category: element.child('category').value.toString(),
                  title: element.child('title').value.toString(),
                  email: element.child('email').value.toString(),
                  show: element.child('show').value.toString()))
              .then((value) {
            getTaskData();
          });
        }
      });
    }
    getTaskData();
  }
  checkData() {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].show == 'yes') {
        count++;
      }
    }
    if (count > 0) {
      hasData.value = true;
      taskCount.value = count;
    } else {
      hasData.value = false;
      taskCount.value = 0;
    }
  }

  popupMenuSelected(int value, int index, BuildContext context) async {
    if (value == 2) {
      Utils.showWarningDailog(context, () => removeFromList(index));
    }
  }

  statusupdate(id, status) async {
    await db.updateTaskStatus(id, status);
    getTaskDatadate();
  }

  getTaskData() async {
    list.value = await db.getDataByEmail(theemail.value);
    var tempList = await db.getPendingUploads();
    for (int i = 0; i < tempList.length; i++) {
      list.add(tempList[i]);
    }
    checkData();
    getTaskDatadate();
  }

  getTaskDatadate() {
    // Clear dlist before adding new tasks
    dlist.clear();

    for (int i = 0; i < list.length; i++) {
      String dateFromDatabase = list[i].date;
      DateTime parsedDate = DateFormat('dd MMM yyyy').parse(dateFromDatabase);

      String formattedDateFromDatabase =
          DateFormat('MM/dd/yyyy').format(parsedDate);

      if (list[i].show == 'yes' &&
          formattedDateFromDatabase ==
              DateFormat('MM/dd/yyyy').format(selectedDate)) {
        dlist.add(list[i]);
        print(dlist);
      }
    }

    checkData();
  }

  int get completedTasksCount =>
      dlist.where((task) => task.status == 'Complete').length;

  // Computed property for the total tasks
  int get totalTasksCount => dlist.length;

  // Computed property for the percentage of completed tasks
  double get completedPercentage {
    if (totalTasksCount == 0) return 0.0;
    return completedTasksCount / totalTasksCount;
  }

  onClear(BuildContext context) {
    searchController.value.text = '';
    hasText.value = false;
    onTapOutside(context);
  }

  onTapOutside(BuildContext context) {
    focus.value = false;
    FocusScope.of(context).unfocus();
  }

  checkText() {
    hasText.value = searchController.value.text.toString().isNotEmpty;
  }

  onTapField() {
    focus.value = true;
  }

  getUserData() async {
    userData.value = await UserPref.getUser();
    getName();
  }

  getName() {
    name.value = userData['NAME']?.toString() ??
        'Guest'; // Use 'Guest' as a fallback if NAME is null
    theemail.value = userData['EMAIL']?.toString() ?? 'unknown';
  }

  removeFromList(int index) {
    db
        .removeFromList(TaskModel(
            key: list[index].key,
            status: list[index].status,
            notification: list[index].notification,
            time: list[index].time,
            date: list[index].date,
            periority: list[index].periority,
            description: list[index].description,
            category: list[index].category,
            title: list[index].title,
            email: list[index].email,
            show: 'no'))
        .then((value) {
      getTaskData();
    });
  }

  void updateTask(TaskModel updatedTask) {
    // db.update(updatedTask).then((value) {
    //   getTaskData();
    // });
  }

  void updateTaskStatus(int index, bool status) {
    var task = list[index];
    task.status = status;
    updateTask(task);
  }

  setStatus() {
    taskstatus.value = !taskstatus.value;
  }
}
