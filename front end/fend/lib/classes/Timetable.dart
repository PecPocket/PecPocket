import 'package:flutter/widgets.dart';

final String tableTimetable = 'Timetable';

class TimetableFields {
  static final List<String> values = [
    id,
    startYear,
    startMonth,
    startDay,
    startHour,
    startMinute,
    endYear,
    endMonth,
    endDay,
    endHour,
    endMinute,
    interval,
  ];
  static final String id = '_id';
  static final String title = 'title';
  static final String startYear = 'StartYear';
  static final String startMonth = 'StartMonth';
  static final String startDay = 'StartDay';
  static final String startHour = 'StartHour';
  static final String startMinute = 'StartMinute';
  static final String endYear = 'EndYear';
  static final String endMonth = 'EndMonth';
  static final String endDay = 'EndDay';
  static final String endHour = 'EndHour';
  static final String endMinute = 'EndMinute';
  static final String interval = 'Interval';
}

class Timetable {
  final int id;
  final String title;
  final int startYear;
  final int startMonth;
  final int startDay;
  final int startHour;
  final int startMinute;
  final int endYear;
  final int endMonth;
  final int endDay;
  final int endHour;
  final int endMinute;
  final int interval;

  const Timetable({
    this.id,
    this.title,
    this.startYear,
    this.startMonth,
    this.startDay,
    this.startHour,
    this.startMinute,
    this.endYear,
    this.endMonth,
    this.endDay,
    this.endHour,
    this.endMinute,
    this.interval,
  });

  Timetable copy({
    int id,
    String title,
    int startYear,
    int startMonth,
    int startDay,
    int startHour,
    int startMinute,
    int endYear,
    int endMonth,
    int endDay,
    int endHour,
    int endMinute,
    int interval,
  }) =>
      Timetable(
        id: id ?? this.id,
        title: title ?? this.title,
        startYear: startYear ?? this.startYear,
        startMonth: startMonth ?? this.startMonth,
        startDay: startDay ?? this.startDay,
        startHour: startHour ?? this.startHour,
        startMinute: startMinute ?? this.startMinute,
        endYear: endYear ?? this.endYear,
        endMonth: endMonth ?? this.endMonth,
        endDay: endDay ?? this.endDay,
        endHour: endHour ?? this.endHour,
        endMinute: endMinute ?? this.endMinute,
        interval: interval ?? this.interval,
      );

  static Timetable fromJson(Map<String, Object> json) => Timetable(
    id: json[TimetableFields.id] as int,
    title: json[TimetableFields.title] as String,
    startYear: json[TimetableFields.startYear] as int,
    startMonth: json[TimetableFields.startMonth] as int,
    startDay: json[TimetableFields.startDay] as int,
    startHour: json[TimetableFields.startHour] as int,
    startMinute: json[TimetableFields.startMinute] as int,
    endYear: json[TimetableFields.endYear] as int,
    endMonth: json[TimetableFields.endMonth] as int,
    endDay: json[TimetableFields.endDay] as int,
    endHour: json[TimetableFields.endHour] as int,
    endMinute: json[TimetableFields.endMinute] as int,
    interval: json[TimetableFields.interval] as int,
  );

  Map<String, Object> toJson() => {
    TimetableFields.id: id,
    TimetableFields.title: title,
    TimetableFields.startYear: startYear,
    TimetableFields.startMonth: startMonth,
    TimetableFields.startDay: startDay,
    TimetableFields.startHour: startHour,
    TimetableFields.startMinute: startMinute,
    TimetableFields.endYear: endYear,
    TimetableFields.endMonth: endMonth,
    TimetableFields.endDay: endDay,
    TimetableFields.endHour: endHour,
    TimetableFields.endMinute: endMinute,
    TimetableFields.interval: interval,
  };
}