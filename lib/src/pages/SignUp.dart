import 'package:_pecpocket/src/App.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  Widget build(context) {
    return MaterialApp(
      title: 'SignUpPage',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
