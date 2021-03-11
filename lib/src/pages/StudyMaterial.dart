import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudyMaterial extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'StudyMaterial',
      home: Scaffold(
        appBar: AppBar(
          title: Text('StudyMaterial'),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
