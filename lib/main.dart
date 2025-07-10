import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/storage_config.dart';

import 'config/firebase_handler.dart';
import 'controllers/auth_controller.dart';
import 'merkastu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigPreference.init();

  bool kisweb;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      kisweb = false;
    } else {
      kisweb = true;
    }
  } catch (e) {
    kisweb = true;
  }
  if (!kisweb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAJWASpaxYWuH_Rxyf2swe4d3LmbzFTlXI",
            appId: "1:1095373800658:android:24c09a5dd5a819c864190b",
            messagingSenderId: "1095373800658",
            projectId: "merkastu-customer"));
    try {
      await FirebaseHandler().initNotifications();
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      FirebaseHandler().initNotifications();
    }
    AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_name',
      [
        NotificationChannel(
            channelKey: 'pill_reminder_channel',
            criticalAlerts: true,
            channelName: 'Pill Reminders',
            defaultColor: const Color(0xFF039D55),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            channelDescription: 'Basic Notifications'),
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            defaultColor: const Color(0xFF039D55),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            channelDescription: 'Basic Notifications'),
        NotificationChannel(
            channelKey: 'channel id',
            channelName: 'Basic Notifications',
            defaultColor: const Color(0xFF039D55),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            channelDescription: 'Basic Notifications'),
        NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'Scheduled Notifications',
            defaultColor: const Color(0xFF039D55),
            locked: true,
            importance: NotificationImportance.High,
            channelDescription: 'Scheduled Notifications'),
      ],
    );
  }
  // if (!kisweb) {
  //   DeepLinkHandler.initDeepLinkListener();
  // }
  UserController.getLoggedInUser();
  runApp(const Merkastu());
}
