import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'TimeTable',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Time Table'),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
