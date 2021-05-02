import 'dart:convert';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/AttendanceDB.dart';
import 'package:fend/Databases/ClubsDB.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/TimetableDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/Databases/customFoldersDB.dart';
import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/classes/CustomReminderDetails.dart';
import 'package:fend/classes/NotiClass.dart';

import 'package:fend/classes/subjects.dart';
import 'package:fend/classes/user.dart';
import 'package:fend/models/Notifications.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/CustomFolder.dart';
import 'package:fend/screens/CustomReminders/CustomReminderAddNew.dart';
import 'package:fend/screens/CustomReminders/CustomReminderView.dart';

import 'package:fend/screens/login_screen.dart';
import 'package:fend/screens/signUp/SignUpPassword.dart';
import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:fend/screens/uploadNotification.dart';

import 'package:fend/models/Notifications.dart';
import 'package:fend/screens/HamburgerMenu.dart';

import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart';

class MainPage extends StatefulWidget {
  createState() {
    return MainPageState();
  }
}
int auth;

class MainPageState extends State<MainPage> {
  void initState() {
    super.initState();
    updateReminder();
    getAuth();
  }

  String deletePassword;
  List notifications = [
    'Enter a new notification?',
    'Notification1',
    'Notification2',
    'Notification3'
  ];
  List<NotiClass> notificationsList = [];

  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomReminderView(),
        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(
              color: Color(0xffCADBE4),
              fontSize: 32,
            ),
          ),
          backgroundColor: Color(0xff588297),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomReminderAddNew();
                      });
                }),
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Color(0xffCADBE4),
                  size: 30,
                ),
                onPressed: () async {
                  var response = await get(
                      Uri.parse('${global.url}/noti/${global.sid}'));

                  setState(() {
                    if (response.body.length > 18) {
                      NotificationList jsonNotification =
                      NotificationList.fromJson(
                          json.decode(response.body));

                      notifications.clear();

                      for (int i = 0;
                      i < jsonNotification.notification.length;
                      i++) {
                        notifications
                            .add(jsonNotification.notification[i].topic);
                        notifications.add(
                            jsonNotification.notification[i].description);
                        notifications
                            .add(jsonNotification.notification[i].date);
                        notifications
                            .add(jsonNotification.notification[i].time);
                        NotiClass newNoti = NotiClass(title: jsonNotification.notification[i].topic, description: jsonNotification.notification[i].description, date: jsonNotification.notification[i].date, time: jsonNotification.notification[i].time);
                        notificationsList.add(newNoti);
                      }
                    } else {
                      notifications.clear();
                      notifications.add('No new notification');
                    }
                  });
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        print(auth);
                        if(auth == 1) {
                          return AlertDialog(
                            title: Text(
                                'Notifications',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff235790),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomReminderAddNew()));
                                  });
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: notificationsList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        color: Color(0xffCADBE4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(height: 10),
                                              Text(
                                                  'Title: ' + notificationsList[index].title,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Description: ' + notificationsList[index].description,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Date: ' + notificationsList[index].date,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Time: ' + notificationsList[index].time,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Container(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        else {
                          return AlertDialog(
                            title: Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff235790),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomReminderAddNew()));
                                  });
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: notificationsList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        color: Color(0xffCADBE4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(height: 10),
                                              Text(
                                                'Title: ' + notificationsList[index].title,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Description: ' + notificationsList[index].description,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Date: ' + notificationsList[index].date,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Time: ' + notificationsList[index].time,
                                                style: TextStyle(
                                                  color: Color(0xff235790),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Container(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadNotification()));
                                  },
                                  child: Icon(Icons.add)
                              ),
                            ],
                          );
                        }
                      });
                }),
          ],
        ),
        drawer: Settings(),
        bottomNavigationBar: bottomAppBar(),
      ),
    );
  }

  setupNotifications() {}

  goToCustomFolders() {
    setState(() {});
  }

  void updateReminder() async {
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

  Future<int> getAuth() async{
    var userHelper = UserDatabase.instance;
    var databaseUsers = await userHelper.getAllUsers();
    int userAuth = databaseUsers[0].auth;
    auth = userAuth;
  }
}
