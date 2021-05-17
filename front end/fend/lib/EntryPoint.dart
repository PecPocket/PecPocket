import 'package:fend/Databases/UserDB.dart';
import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/screens/CustomReminders/CustomReminderView.dart';
import 'package:fend/screens/introduction.dart';
import 'package:fend/screens/login_screen.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Databases/AvatarDB.dart';
import 'classes/CustomReminderDetails.dart';

class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

int login;

class _EntryPointState extends State<EntryPoint> {
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Color(0xff272727),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
    checkLogin();
    updateReminders();
    getAvatar();
    updateMainPageReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void checkLogin() async {
    var dbHelper = UserDatabase.instance;
    var user = await dbHelper.getAllUsers();
    int count = await dbHelper.isEmpty();
    print(count);
    setState(
      () {
        if (count == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => IntroScreen()));
        } else if (user[0].login == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else if (user[0].login == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        }
      },
    );
  }

  void updateReminders() async {
    var reminderHelper = ReminderDatabase.instance;
    var databaseReminder = await reminderHelper.getAllReminders();
    print(databaseReminder.length);
    customReminders.clear();
    for (int i = 0; i < databaseReminder.length; i++) {
      DateTime dateTime = new DateTime(
          databaseReminder[i].year,
          databaseReminder[i].month,
          databaseReminder[i].day,
          databaseReminder[i].hour,
          databaseReminder[i].minute);
      customReminders.add(CustomReminderDetails(
          0,
          databaseReminder[i].title, //add title here
          databaseReminder[i].description,
          dateTime,
          databaseReminder[i].getNotified));
    }
  }

  void getAvatar() async {
    var avatarHelper = AvatarDatabase.instance;
    var databaseAvatar = await avatarHelper.getAllavatar();
    selectedAvatar = databaseAvatar[0].avatar;
    print(databaseAvatar.length);
  }

  void updateMainPageReminders() async {
    var reminderHelper = ReminderDatabase.instance;
    var databaseReminder = await reminderHelper.getAllReminders();
    print('reminder count ${databaseReminder.length}');
    customReminders.clear();
    mainPageReminders.clear();
    mainPageReminderDescriptions.clear();
    mainPageReminderStartTimes.clear();
    mainPageReminderEndTimes.clear();
    for (int i = 0; i < databaseReminder.length; i++) {
      DateTime dateTime = new DateTime(
          databaseReminder[i].year,
          databaseReminder[i].month,
          databaseReminder[i].day,
          databaseReminder[i].hour,
          databaseReminder[i].minute);

      customReminders.add(
        CustomReminderDetails(
            0,
            databaseReminder[i].title, //add title here
            databaseReminder[i].description,
            dateTime,
            databaseReminder[i].getNotified),
      );

      mainPageReminders.add('${databaseReminder[i].title}');
      mainPageReminderDescriptions.add(databaseReminder[i].description);
      if (databaseReminder[i].hour < 10) {
        if (databaseReminder[i].minute > 9) {
          mainPageReminderStartTimes.add('0${databaseReminder[i].hour}' +
              ':' +
              '${databaseReminder[i].minute}');
          mainPageReminderEndTimes.add('0${databaseReminder[i].hour}' +
              ':' +
              '${databaseReminder[i].minute}');
        } else {
          mainPageReminderStartTimes.add('0${databaseReminder[i].hour}' +
              ':' +
              '${databaseReminder[i].minute}');
          mainPageReminderEndTimes.add('0${databaseReminder[i].hour}' +
              ':' +
              '0${databaseReminder[i].minute}');
        }
      } else {
        if (databaseReminder[i].minute > 9) {
          mainPageReminderStartTimes.add('${databaseReminder[i].hour}' +
              ':' +
              '${databaseReminder[i].minute}');
          mainPageReminderEndTimes.add('${databaseReminder[i].hour}' +
              ':' +
              '${databaseReminder[i].minute}');
        } else {
          mainPageReminderStartTimes.add('${databaseReminder[i].hour}' +
              ':' +
              '${databaseReminder[i].minute}');
          mainPageReminderEndTimes.add('${databaseReminder[i].hour}' +
              ':' +
              '0${databaseReminder[i].minute}');
        }
      }
    }
    reminderLength = customReminders.length;
  }
}
