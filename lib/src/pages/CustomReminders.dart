import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomReminders extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'Custom Reminders',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Reminders'),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
