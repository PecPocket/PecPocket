import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Meeting.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments[index].toZone;
  }

  @override
  List<DateTime> getRecurrenceExceptionDates(int index) {
    return appointments[index].exceptionDates;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments[index].recurrenceRule;
  }

  @override
  String getStartTimeZone(int index) {
    return appointments[index].fromZone;
  }

  @override
  String getSubject(int index) {
    return appointments[index].title;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}
