import 'dart:convert';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:fend/Databases/AvatarDB.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/EntryPoint.dart';
import 'package:fend/classes/CustomReminderDetails.dart';
import 'package:fend/classes/NotiClass.dart';
import 'package:fend/classes/Profile.dart';
import 'package:fend/classes/Reminder.dart';
import 'package:fend/classes/subjects.dart';
import 'package:fend/models/Notifications.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/CustomReminders/CustomReminderAddNew.dart';
import 'package:fend/screens/CustomReminders/CustomReminderView.dart';
import 'package:fend/screens/ViewProfile.dart';
import 'package:fend/screens/uploadNotification.dart';
import 'package:fend/screens/HamburgerMenu.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import 'StudyMaterial/StudyMaterial0.dart';

class MainPage extends StatefulWidget {
  createState() {
    return MainPageState();
  }
}

String selectedAvatar = 'assets/41.png';
int auth;
int reminderLength = customReminders.length;
List<String> mainPageReminders = ['', '', ''];
List<String> mainPageReminderStartTimes = ['', '', ''];
List<String> mainPageReminderEndTimes = ['', '', ''];
List<String> mainPageReminderDescriptions = ['', '', ''];

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  AnimationController animationController;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    getAuth();
    updateProfile();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  var key = GlobalKey<ScaffoldState>();
  String deletePassword;
  List notifications = [
    'Enter a new notification?',
    'Notification1',
    'Notification2',
    'Notification3'
  ];
  List<NotiClass> notificationsList = [];
  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 8,
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomReminderAddNew();
                });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        key: key,
        body: DraggableBottomSheet(
          backgroundWidget: Scaffold(
            body: Center(
              child: Container(
                alignment: Alignment.topCenter,
                color: Colors.teal,
                child: Image(
                  image: AssetImage('assets/custom_reminders.png'),
                  height: 250,
                ),
              ),
            ),
          ),
          previewChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16)),
                ),
                SizedBox(
                  height: 16,
                ),
                customReminders.length == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                              ),
                              Image.asset(
                                'assets/custom_reminder.png',
                                height: 200,
                                width: 200,
                              ),
                              Text(
                                'Looks like you have not added a reminder. Click the + button to add one.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: customReminders.length > 3
                                ? 3
                                : customReminders.length,
                            itemBuilder: (context, index) {
                              reminderLength = customReminders.length;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(colorChoices[index]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        height: 120,
                                        width: 4,
                                      ),
                                      SizedBox(
                                        height: 100,
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                customReminders[index]
                                                        .reminderDateTime
                                                        .day
                                                        .toString() +
                                                    '-' +
                                                    customReminders[index]
                                                        .reminderDateTime
                                                        .month
                                                        .toString() +
                                                    '-' +
                                                    customReminders[index]
                                                        .reminderDateTime
                                                        .year
                                                        .toString(),
                                                style: GoogleFonts.exo2(),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                height: 1,
                                                width: 215,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            mainPageReminders[index],
                                            style: GoogleFonts.exo2(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 325,
                                            child: Text(
                                              mainPageReminderDescriptions[
                                                  index],
                                              style: GoogleFonts.exo2(),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                mainPageReminderEndTimes[index],
                                                style: GoogleFonts.exo2(),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                height: 1,
                                                width: 240,
                                                color: Colors.grey,
                                              ),
                                              IconButton(
                                                icon:
                                                    Icon(Icons.cancel_outlined),
                                                onPressed: () async {
                                                  var reminderHelper =
                                                      ReminderDatabase.instance;
                                                  reminderHelper.deleteReminder(
                                                      mainPageReminderDescriptions[
                                                          index]);
                                                  mainPageReminders
                                                      .removeAt(index);
                                                  mainPageReminderDescriptions
                                                      .removeAt(index);
                                                  mainPageReminderStartTimes
                                                      .removeAt(index);
                                                  mainPageReminderEndTimes
                                                      .removeAt(index);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EntryPoint()));
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  )
                                ],
                              );
                            }),
                      ),
              ],
            ),
          ),
          expandedChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16)),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: reminderLength,
                      itemBuilder: (context, index) {
                        reminderLength = customReminders.length;
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(colorChoices[index]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 100,
                                  width: 4,
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          customReminders[index]
                                                  .reminderDateTime
                                                  .day
                                                  .toString() +
                                              '-' +
                                              customReminders[index]
                                                  .reminderDateTime
                                                  .month
                                                  .toString() +
                                              '-' +
                                              customReminders[index]
                                                  .reminderDateTime
                                                  .year
                                                  .toString(),
                                          style: GoogleFonts.exo2(),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          height: 1,
                                          width: 250,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      mainPageReminders[index],
                                      style: GoogleFonts.exo2(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      width: 325,
                                      child: Text(
                                        mainPageReminderDescriptions[index],
                                        style: GoogleFonts.exo2(),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          mainPageReminderEndTimes[index],
                                          style: GoogleFonts.exo2(),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          height: 1,
                                          width: 240,
                                          color: Colors.grey,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.cancel_outlined),
                                          onPressed: () async {
                                            var reminderHelper =
                                                ReminderDatabase.instance;
                                            reminderHelper.deleteReminder(
                                                mainPageReminderDescriptions[
                                                    index]);
                                            mainPageReminders.removeAt(index);
                                            mainPageReminderDescriptions
                                                .removeAt(index);
                                            mainPageReminderStartTimes
                                                .removeAt(index);
                                            mainPageReminderEndTimes
                                                .removeAt(index);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EntryPoint()));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
          minExtent: 400,
          maxExtent: MediaQuery.of(context).size.height * 1,
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: AnimatedIcon(
              color: Colors.black,
              icon: AnimatedIcons.menu_close,
              progress: animationController,
            ),
            onPressed: () => handleOnPressed(),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                onPressed: () async {
                  var userHelper = UserDatabase.instance;
                  var databaseUser = await userHelper.getAllUsers();
                  var response = await get(
                      Uri.parse('${global.url}noti/${databaseUser[0].sid}'));

                  setState(() {
                    if (response.body.length > 18) {
                      NotificationList jsonNotification =
                          NotificationList.fromJson(json.decode(response.body));

                      notifications.clear();

                      for (int i = 0;
                          i < jsonNotification.notification.length;
                          i++) {
                        notifications
                            .add(jsonNotification.notification[i].topic);
                        notifications
                            .add(jsonNotification.notification[i].description);
                        notifications
                            .add(jsonNotification.notification[i].date);
                        notifications
                            .add(jsonNotification.notification[i].time);
                        NotiClass newNoti = NotiClass(
                            title: jsonNotification.notification[i].topic,
                            description:
                                jsonNotification.notification[i].description,
                            date: jsonNotification.notification[i].date,
                            time: jsonNotification.notification[i].time);
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
                        if (auth == 0) {
                          if (notificationsList.length == 0) {
                            return AlertDialog(
                              title: Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff272727),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Container(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                        ),
                                        Image.asset(
                                          'assets/noti.png',
                                          height: 250,
                                          width: 250,
                                        ),
                                        Text(
                                          'No new notification',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntryPoint()));
                                    },
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(fontSize: 17.5),
                                    ))
                              ],
                            );
                          }
                          return AlertDialog(
                            title: Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      String reminderTitle =
                                          notificationsList[index].title;
                                      String reminderDescription =
                                          notificationsList[index].description;
                                      List<String> dateList =
                                          notificationsList[index]
                                              .date
                                              .split('-');
                                      List<String> timeList =
                                          notificationsList[index]
                                              .time
                                              .split(':');
                                      DateTime notificationDateTime =
                                          new DateTime(
                                        int.parse(dateList[2]),
                                        int.parse(dateList[1]),
                                        int.parse(dateList[0]),
                                        int.parse(timeList[0]),
                                        int.parse(timeList[1]),
                                      );
                                      print(reminderTitle);
                                      customReminders.add(CustomReminderDetails(
                                          0,
                                          reminderTitle, //add title here
                                          reminderDescription,
                                          notificationDateTime,
                                          true));

                                      var reminderHelper =
                                          ReminderDatabase.instance;
                                      Reminder reminder = Reminder(
                                        id: 0,
                                        title: reminderTitle,
                                        description: reminderDescription,
                                        year: int.parse(dateList[2]),
                                        month: int.parse(dateList[1]),
                                        day: int.parse(dateList[0]),
                                        hour: int.parse(timeList[0]),
                                        minute: int.parse(timeList[1]),
                                        getNotified: true,
                                      );

                                      reminderHelper.create(reminder);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntryPoint()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff272727),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Title',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index].title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Description',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index]
                                                  .description,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Date',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index].date,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Time',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index].time,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: notificationsList.length,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EntryPoint()));
                                  },
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(fontSize: 17.5),
                                  ))
                            ],
                          );
                        } else {
                          if (notificationsList.length == 0) {
                            return AlertDialog(
                              title: Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff272727),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Container(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                        ),
                                        Image.asset(
                                          'assets/noti.png',
                                          height: 250,
                                          width: 250,
                                        ),
                                        Text(
                                          'No new notification',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UploadNotification()));
                                    },
                                    child: Icon(Icons.add)),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntryPoint()));
                                    },
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(fontSize: 17.5),
                                    ))
                              ],
                            );
                          }
                          return AlertDialog(
                            title: Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      String reminderDescription =
                                          notificationsList[index].title;

                                      notificationsList[index].description;
                                      List<String> dateList =
                                          notificationsList[index]
                                              .date
                                              .split('-');
                                      List<String> timeList =
                                          notificationsList[index]
                                              .time
                                              .split(':');
                                      DateTime notificationDateTime =
                                          new DateTime(
                                        int.parse(dateList[2]),
                                        int.parse(dateList[1]),
                                        int.parse(dateList[0]),
                                        int.parse(timeList[0]),
                                        int.parse(timeList[1]),
                                      );

                                      customReminders.add(CustomReminderDetails(
                                          0,
                                          'title', //add title here
                                          reminderDescription,
                                          notificationDateTime,
                                          true));

                                      var reminderHelper =
                                          ReminderDatabase.instance;
                                      Reminder reminder = Reminder(
                                        id: 0,
                                        description: reminderDescription,
                                        year: int.parse(dateList[2]),
                                        month: int.parse(dateList[1]),
                                        day: int.parse(dateList[0]),
                                        hour: int.parse(timeList[0]),
                                        minute: int.parse(timeList[1]),
                                        getNotified: true,
                                      );

                                      reminderHelper.create(reminder);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntryPoint()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff272727),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Title',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index].title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Description',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index]
                                                  .description,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Date',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index].date,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Time',
                                              style: TextStyle(
                                                color: Color(0xff0B7A75),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              notificationsList[index].time,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: notificationsList.length,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadNotification()));
                                  },
                                  child: Icon(Icons.add)),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EntryPoint()));
                                  },
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(fontSize: 17.5),
                                  ))
                            ],
                          );
                        }
                      });
                }),
            GestureDetector(
                child: Container(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(selectedAvatar),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewProfile()));
                }),
            SizedBox(width: 15)
          ],
        ),
        drawer: Settings(),
        bottomNavigationBar: bottomAppBar(),
      ),
    );
  }

  Future<int> getAuth() async {
    var userHelper = UserDatabase.instance;
    var databaseUsers = await userHelper.getAllUsers();
    int userAuth = databaseUsers[0].auth;
    auth = userAuth;
  }

  handleOnPressed() async {
    if (!isPlaying) {
      await animationController.forward();
      key.currentState?.openDrawer();
      animationController.reverse();
    }
    setState(() {
      print(isPlaying);
    });
  }

  void updateProfile() async {
    var avatarHelper = AvatarDatabase.instance;
    var userAvatar = await avatarHelper.getAllavatar();
    var userHelper = UserDatabase.instance;
    var databaseUser = await userHelper.getAllUsers();
    var sid = databaseUser[0].sid;
    var response = await get(Uri.parse('${global.url}viewprofile/$sid'));
    Social profile = Social.fromJson(json.decode(response.body));
    setState(() {
      profileName = profile.name;
      profileSid = profile.sid.toString();
      profileClubs = profile.clubs.length == 0
          ? ' Not in any clubs '
          : profile.clubs.toString();
      profileBranch = profile.branch.toString();
      profileYear = profile.year.toString();
      profileSemester = profile.semester.toString();
      profileInsta =
          profile.insta == null ? 'No instagram handle' : profile.insta;
      profileAvatar = selectedAvatar;
    });
  }

  getDayFromReminder(int day) {
    switch (day) {
      case 1:
        return 'Monday';
        break;
      case 2:
        return 'Tuesday';
        break;
      case 3:
        return 'Wednesday';
        break;
      case 4:
        return 'Thursday';
        break;
      case 5:
        return 'Friday';
        break;
      case 6:
        return 'Saturday';
        break;
      case 7:
        return 'Sunday';
        break;
    }
  }
}
