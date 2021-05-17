import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/EntryPoint.dart';
import 'package:fend/classes/CustomReminderDetails.dart';
import 'package:fend/classes/Reminder.dart';
import 'package:fend/screens/CustomReminders/CustomReminderView.dart';
import 'package:fend/screens/CustomReminders/pushNotifications.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class CustomReminderAddNew extends StatefulWidget {
  @override
  _CustomReminderAddNewState createState() => _CustomReminderAddNewState();
}

class _CustomReminderAddNewState extends State<CustomReminderAddNew> {
  final notifications = FlutterLocalNotificationsPlugin();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final myController = TextEditingController();
  DateTime selectedDate;
  TimeOfDay selectedTime;
  DateTime selectedDateTime;
  String userTitle;
  String userDescription;
  bool getNotif = true;
  int uid = 0;
  int toAdd = 0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: AppBar(
        backgroundColor: Color(0xff272727),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            color: Color(0xff272727),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Set Custom Reminder",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  controller: titleController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'TITLE',
                    labelStyle: TextStyle(
                      color: Color(0x95ffffff),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  validator: (val) {
                    return val.isEmpty ? 'Enter the title of the task' : null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'DESCRIPTION',
                    labelStyle: TextStyle(
                      color: Color(0x95ffffff),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  validator: (val) {
                    return val.isEmpty
                        ? 'Enter the description of the task'
                        : null;
                  },
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 330,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate(selectedDate),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        selectedDate = await _selectDate(context);
                        setState(() {
                          toAdd = 1;
                          print('toAdd $toAdd');
                        });
                      },
                      icon: Icon(Icons.calendar_today_rounded),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTime(selectedTime),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        selectedTime = await _selectTime(context);
                        setState(() {
                          toAdd = 2;
                          print('toAdd $toAdd');
                        });
                      },
                      icon: Icon(Icons.timer),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 200,
                    child: SwitchListTile(
                      title: Text(
                        "Get Notified",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      activeColor: Color(0xff272727),
                      value: getNotif,
                      onChanged: (newValue) {
                        setState(() {
                          getNotif = newValue;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    userTitle = titleController.text;
                    userDescription = descriptionController.text;

                    var reminderHelper = ReminderDatabase.instance;

                    Reminder reminder = Reminder(
                        id: 0,
                        title: userTitle,
                        description: userDescription,
                        year: selectedDate.year,
                        month: selectedDate.month,
                        day: selectedDate.day,
                        hour: selectedTime.hour,
                        minute: selectedTime.minute,
                        getNotified: getNotif);

                    selectedDateTime = new DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute);
                    customReminders.add(
                      CustomReminderDetails(uid, userTitle, userDescription,
                          selectedDateTime, getNotif),
                    );
                    setState(
                      () {
                        reminderHelper.create(reminder);
                      },
                    );
                    if (getNotif) {
                      pushNotification.schedulePushNotification(0, userTitle, userDescription, selectedDateTime);
                    }

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => EntryPoint()));
                  },
                  child: Text('Create Reminder'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff272727),
                    minimumSize: Size(MediaQuery.of(context).size.width, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff272727),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return pickedDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        helpText: "Time of Reminder",
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xff272727),
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    return pickedTime;
  }

  String formattedDate(DateTime date) {
    if (date == null) {
      return 'Select Date';
    }
    return DateFormat("EEEE, d MMMM").format(date);
  }

  String formattedTime(TimeOfDay time) {
    if (time == null) {
      return 'Select Time';
    }
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time);
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }
}
