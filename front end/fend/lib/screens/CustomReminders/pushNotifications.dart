import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as t;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}


class PushNotification{

  Future<void> schedulePushNotification(int id, String title, String body, DateTime notiTime_dt) async {
    //final timeZone = TimeZone();
    //String timeZoneName = await timeZone.getTimeZoneName();
    //final location = await timeZone.getLocation('IST');
    tz.TZDateTime notiTime = tz.TZDateTime.from(notiTime_dt, tz.local);

    //print(notiTime_dt);
    //print(notiTime);
    //print(timeZoneName);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        notiTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            'description',
            importance: Importance.max,
            priority: Priority.high,
            timeoutAfter: 5,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}

PushNotification pushNotification = PushNotification();

