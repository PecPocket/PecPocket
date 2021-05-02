import 'package:fend/EntryPoint.dart';
import 'package:fend/screens/login_screen.dart';
import 'package:fend/screens/signUp/SignUpClubs.dart';
import 'package:fend/screens/signUp/SignUpEmail.dart';
import 'package:fend/screens/signUp/SignUpPassword.dart';
import 'package:fend/screens/signUp/SignUpSubjects.dart';
import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}
