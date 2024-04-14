import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class NotificationUtils {
  static late BuildContext mainContext;
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'Scavenger Hunt', 'ScavHunt',
      importance: Importance.max, playSound: true);

  static FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> showNotification(RemoteMessage payload) async {
    RemoteNotification? notification = payload.notification;
    Map<String, dynamic> notificationData = payload.data;
    if (notification == null) return;
    await plugin.show(
        1,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
          ),
          android: AndroidNotificationDetails(channel.id, channel.name,
              color: ColorStyle.primaryColor,
              playSound: true,
              priority: Priority.max,
              styleInformation:
                  BigTextStyleInformation(notification.body ?? ""),
              icon: '@drawable/ic_notification'),
        ),
        payload: json.encode(notificationData));
  }

  static void initializeFirebase(BuildContext context) async {
    mainContext = context;
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await plugin.initialize(initializationSettings);

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> handleInitialMessage(RemoteMessage? message) async {
    if (message != null) {
      Map<String, dynamic> notificationData = message.data;
      _performNotificationTap(
          notificationData["action"], notificationData["id"].toString());
    }
  }

  static Future<void> notificationHandler(String? payload) async {
    if (payload != null) {
      Map<String, dynamic> data = json.decode(payload);
      _performNotificationTap(data["action"].toString(), data["id"].toString());
    }
  }

  static void _performNotificationTap(String action, String id) {
    // if (NavigatorRoutes.isRouteInStack(baseRoute)) {
    //   BaseScreen.eventBus.fire(NotificationRecieved(action: action, id: id));
    //   "directNotif");
    // } else {
    //   PrefUtil().lastNotificationAction =
    //       NotificationAction(action: action, id: id);
    //   "prefNotif");
    // }

    // ("notif:${PrefUtil().lastNotificationAction}"));
  }
}
