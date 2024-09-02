import 'dart:core';

class TaskModel {
  String? key;
  String? title;
  String? category;
  String? description;
  String? email;
  String? periority;
  String? time;
  String? date;
  String? show;
  String? notification;
  String? status;

  TaskModel(
      {required this.key,
      required this.time,
      required this.date,
      required this.periority,
      required this.description,
      required this.category,
      required this.title,
      required this.email,
      required this.show,
      required this.notification,
      required this.status});

  TaskModel.fromMap(Map<String, dynamic> res) {
    key = res['key'];
    title = res['title'];
    category = res['category'];
    description = res['description'];
    email = res['email'];
    periority = res['periority'];
    show = res['show'];
    time = res['time'];
    date = res['date'];
    notification = res['notification'];
    status = res['status'];
  }

  Map<String, Object?> toMap() {
    return {
      'key': key,
      'title': title,
      'category': category,
      'description': description,
      'email': email,
      'periority': periority,
      'time': time,
      'date': date,
      'show': show,
      'status': status,
      'notification': notification,
    };
  }
}
