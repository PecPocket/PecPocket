import 'dart:ui';
import 'package:flutter/material.dart';

class Meeting {
  Meeting(
      {this.from,
      this.to,
      this.title,
      this.isAllDay,
      this.background,
      this.fromZone,
      this.toZone,
      this.exceptionDates,
      this.recurrenceRule});

  DateTime from;
  DateTime to;
  String title;
  bool isAllDay;
  Color background;
  String fromZone;
  String toZone;
  String recurrenceRule;
  List<DateTime> exceptionDates;
}
