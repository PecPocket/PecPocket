import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/classes/CustomReminderDetails.dart';
import 'package:fend/classes/Reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomReminderCard.dart';

class CustomReminderView extends StatefulWidget {
  @override
  _CustomReminderViewState createState() => _CustomReminderViewState();
}

List<CustomReminderDetails> customReminders = [];

class _CustomReminderViewState extends State<CustomReminderView> {
  @override
  void initState() {
    super.initState();
    updateCustomRemindersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: customReminders.length,
        itemBuilder: (context, index) {
          //(DateTime.now().add(Duration(days: 2)).isBefore(customReminders[index].reminderDateTime))
          //(customReminders[index].reminderDateTime.isBefore(DateTime.now().add(const Duration(days: 2))))
          if (customReminders[index]
              .reminderDateTime
              .add(const Duration(days: 2))
              .isBefore(DateTime.now())) {
            customReminders.removeAt(index);
            return null;
          } else {
            return CustomReminderCard(
              customReminder: customReminders[index],
            );
          }
        },
      ),
    );
  }

  void updateCustomRemindersList() async {
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
