import 'package:fend/EntryPoint.dart';
import 'package:fend/classes/Timetable.dart';
import 'package:fend/screens/CustomReminders/CustomReminderAddNew.dart';
import 'package:fend/screens/HamburgerMenuOptions/AddClubs.dart';
import 'package:fend/screens/HamburgerMenuOptions/AddSubjects.dart';
import 'package:fend/screens/TimeTable.dart';
import 'package:fend/screens/attendance.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:fend/screens/signUp/SignUpAvatarChoice.dart';
import 'package:fend/screens/signUp/SignUpClubs.dart';
import 'package:fend/screens/signUp/SignUpSubjects.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.exo2TextTheme(
        Theme.of(context).textTheme,
      )),
      home: Scaffold(
        body: EntryPoint(),
      ),
    );
  }
}
