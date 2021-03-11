import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Resources extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'My Resources',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Resources'),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
