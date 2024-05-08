// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'noti_service.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final _notiSettings = NotificationsSetting();

  static Future init() async {
    //if web will return none
    if (kIsWeb || Platform.isLinux) return;
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: bgNotiResponse,
      onDidReceiveNotificationResponse: fgNotiResponse,
    );
    tz.initializeTimeZones();
  }

  static Future _notificationsDetail() async {
    return NotificationDetails(
      android: _notiSettings.androidNotiDetails(),
      iOS: _notiSettings.iosNotiDetails(),
    );
  }

  static Future showNotififation(
      {int id = 0, String? title, String? body, String? payload}) async {
    //if web will return none
    if (kIsWeb || Platform.isLinux) return;
    return _notifications.show(
      id,
      title ?? 'Empty Title',
      body ?? 'Empty Body',
      await _notificationsDetail(),
      payload: payload ?? 'Empty Payload',
    );
  }

  static Future showPeriodicNotification(
      {required int id,
      required String title,
      required String body,
      required RepeatInterval repeatInterval,
      String? payload}) async {
    if (kIsWeb || Platform.isLinux) return;

    return _notifications.periodicallyShow(
        id, title, body, repeatInterval, await _notificationsDetail(),
        payload: payload);
  }

  static Future setScheduledNotification({
    required int id,
    required String title,
    required String body,
    required String? payload,
    required DateTime start,
    required DateTime end,
  }) async {
    //if web will return none
    if (kIsWeb || Platform.isLinux) return;
    DateTime startDatetime = start;
    DateTime endDatetime = end;

    Duration difference = endDatetime.difference(startDatetime);
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(DateTime.now().add(difference), tz.local),
      await _notificationsDetail(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static void stopNotification({required int id}) {
    //if web will return none
    if (kIsWeb || Platform.isLinux) return;
    _notifications.cancel(id);
  }
}
