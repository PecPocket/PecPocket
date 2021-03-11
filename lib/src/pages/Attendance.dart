import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'Attendance',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
