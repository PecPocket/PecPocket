import 'package:fend/Databases/UserDB.dart';
import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/screens/CustomReminders/CustomReminderView.dart';
import 'package:fend/screens/login_screen.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/material.dart';

import 'classes/CustomReminderDetails.dart';

class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

int login;

class _EntryPointState extends State<EntryPoint> {
  void initState() {
    super.initState();
    checkLogin();
    updateReminders();
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
    setState(() {
      if (count == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp1()));
      } else if (user[0].login == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      } else if (user[0].login == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
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
          databaseReminder[i].description,
          dateTime,
          databaseReminder[i].getNotified));
    }
  }
}
