import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

NotificationPlugin notificationPlugin = NotificationPlugin._();

class NotificationPlugin {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleddNotification(theTime, String tasktitle) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      "Next Task : ${tasktitle}",
      // summaryText: 'You have A Task',
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      color: const Color.fromRGBO(
          0, 204, 102, 1), // Accent color for notification icon
      icon:
          '@mipmap/launcher_icon', // Make sure this icon exists and is a proper notification icon
      enableLights: true,
      ledColor: const Color(0xFFFFA500),
      ledOnMs: 1000,
      ledOffMs: 500,
      styleInformation: bigTextStyleInformation,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'You have A Task',
      'This notification was scheduled 10 seconds ago.',
      theTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("Notification Scheduled");
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: "channel_desc",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    print("{{{{{{{{{{{{{{{{{{{{{object}}}}}}}}}}}}}}}}}}}}}");

    //  var iosChannelSpecifics = IOSNotificationDetails(subtitle: "This is the subtitle in ios");
    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      'This title is for testing purpose in simple notification',
      'This body is for besting purpose in simple notification', //null
      platformChannelSpecifics,
      payload: 'New Payload',
    );
  }
}
