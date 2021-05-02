import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/classes/CustomReminderDetails.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../EntryPoint.dart';
import 'CustomReminderView.dart';

class CustomReminderCard extends StatelessWidget {
  final CustomReminderDetails customReminder;
  CustomReminderCard({this.customReminder});
  String notifRequired = 'No';
  int overdueColour = 0xffCADBE4;

  @override
  Widget build(BuildContext context) {
    if (customReminder.alarmRequired) {
      notifRequired = 'Yes';
    }

    if (customReminder.reminderDateTime.isBefore(DateTime.now())) {
      overdueColour = 0xffE28F22;
    }

    return Card(
      margin: EdgeInsets.fromLTRB(30, 16, 30, 0),
      color: Color(0xffCADBE4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.circle,
                        size: 16,
                        color: Color(overdueColour),
                      ),
                    ),
                    TextSpan(
                      text: "Overdue",
                      style: TextStyle(
                          color: Color(overdueColour),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              customReminder.description,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 0, 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Color(0xffE28F22),
                      ),
                    ),
                    TextSpan(
                      text:
                          " ${DateFormat(' dd-MM-yyyy').format(customReminder.reminderDateTime)}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.alarm,
                        size: 20,
                        color: Color(0xffE28F22),
                      ),
                    ),
                    TextSpan(
                      text:
                          "  ${DateFormat('HH:mm').format(customReminder.reminderDateTime)}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Get Notification: $notifRequired',
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Color(0xff235790),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: Text(
                              'Delete Reminder (${customReminder.description})'),
                          actions: <Widget>[
                            new TextButton(
                                child: new Text(
                                  'Cancel',
                                  style: TextStyle(color: Color(0xff235790)),
                                ),
                                onPressed: () => Navigator.of(context).pop()),
                            new TextButton(
                              child: new Text(
                                'Delete',
                                style: TextStyle(color: Color(0xff235790)),
                              ),
                              onPressed: () {
                                customReminders.remove(customReminder);
                                deleteCustomReminder(
                                    customReminder.description);
                                var reminderHelper = ReminderDatabase.instance;
                                reminderHelper
                                    .deleteReminder(customReminder.description);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EntryPoint()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteCustomReminder(String description) async {
    var dbHelper = ReminderDatabase.instance;
    dbHelper.deleteReminder(description);
  }
}
