import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Attendance.dart';
import 'CustomReminders.dart';
import 'Resources.dart';
import 'StudyMaterial.dart';
import 'Timetable.dart';

class MainPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Resources'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(margin: EdgeInsets.only(left: 30.0)),
          Container(margin: EdgeInsets.only(top: 250.0)),
          ElevatedButton(
            child: Text('Time Table'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimeTable()),
              );
            },
          ),
          ElevatedButton(
            child: Text('Tendance'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Attendance()),
              );
            },
          ),
          ElevatedButton(
            child: Text('Custom Reminders'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomReminders()),
              );
            },
          ),
          ElevatedButton(
            child: Text('StudyMaterial'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudyMaterial()),
              );
            },
          ),
          ElevatedButton(
            child: Text('My Resources'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Resources()),
              );
            },
          ),
        ],
      ),
    );
  }
}
