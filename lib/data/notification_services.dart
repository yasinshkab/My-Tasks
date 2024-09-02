import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    await _configureLocalTimezone();

    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');


    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Request Permissions for iOS
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification permission granted');
      } else {
        print('Notification permission denied');
      }
    }
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      PermissionStatus status = await Permission.scheduleExactAlarm.request();
      if (status.isGranted) {
        print('Exact alarm permission granted');
      } else {
        print('Exact alarm permission denied');
      }
    }
  }

// Request Permissions for Android
  Future<void> requestAndroidPermissions() async {
    await requestNotificationPermission();
    await requestExactAlarmPermission();
  }

  Future<bool> requestScheduleExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      return true;
    } else {
      await Permission.scheduleExactAlarm.isDenied.then((value) {
        if (value) {
          Permission.scheduleExactAlarm.request();
        }
      });
      return false;
    }
  }

  // Immediate Notification
  Future<void> displayNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      playSound: true,
      icon: 'mipmap-hdpi',
      sound: RawResourceAndroidNotificationSound('mixkit_urgen_loop'),
      largeIcon: DrawableResourceAndroidBitmap('mipmap-hdpi'),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: "$title | $body |",
    );
  }

  //  Scheduled Notification
  Future<void> scheduledNotification(
    int hour,
    int minutes,
  ) async {
    // Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    String msg;
    msg = "🔴Now your task starting⏰.";

    tz.TZDateTime scheduledDate = await _convertTime(hour, minutes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      5,
      "🔴hguigugytfyfyf",
      "      task.note",
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          playSound: true,
          icon: 'mipmap-hdpi',
          sound: const RawResourceAndroidNotificationSound('mixkit_urgen_loop'),
          // largeIcon: const DrawableResourceAndroidBitmap('app_icon'),
          subText: msg,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "task.title}|{task.note}|  task.startTime}|",
    );
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<tz.TZDateTime> _convertTime(int hour, int minutes) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    try {
      tz.setLocalLocation(tz.getLocation(timeZone));
    } catch (e) {
      // If the location is not found, set a default location
      tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
    }
  }
}
