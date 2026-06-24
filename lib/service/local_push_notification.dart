import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
      try {
           Random random = new Random();
      int id = random.nextInt(1000);
       final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "mychanel",
            "my chanel",
            // "my chanel",
            importance: Importance.max,
            priority: Priority.high,

          )

      );
          await _flutterLocalNotificationsPlugin.show(

        id,
        message.notification!.title,
        message.notification!.title,
        notificationDetails,);
      }
      on Exception catch (e) {
    }
  }
}
