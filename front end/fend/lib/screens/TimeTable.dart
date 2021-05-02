import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/TimetableDB.dart';
import 'package:fend/classes/Timetable.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekday_selector/weekday_selector.dart';

import 'HamburgerMenu.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key key}) : super(key: key);
  @override
  _TimeTableState createState() => _TimeTableState();
}

List<Meeting> meetings = <Meeting>[];
List<Color> colors = [
  Color(0xffD9B6A9),
  Color(0xffFF9990),
  Color(0xff9ED2C0),
  Color(0xffC2DEE5),
  Color(0xffDCC0EC),
  Color(0xffE8C6AE),
  Color(0xffB2829D),
  Color(0xff55AAB2),
  Color(0xffABA68E),
  Color(0xffD3D896),
];

List<String> timetableSubjectsList = ['Subjects'];
List<String> timetableSubtitlesList = ['Lecture', 'Tutorial', 'Lab'];
String subject = timetableSubjectsList[0];
String subtitle = 'Lecture';
DateTime now = new DateTime.now();
DateTime firstDateOfWeek;
int selectedDay;
DateTime selectedDate = new DateTime.now();
String help;
String title;
TimeOfDay initial = TimeOfDay(hour: 0, minute: 0);
TimeOfDay from = TimeOfDay(hour: 0, minute: 0);
TimeOfDay till = TimeOfDay(hour: 0, minute: 0);
DateTime from_dt;
DateTime till_dt;
String titleSubject;
String titleSubtitle;

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timetable',
          style: TextStyle(
            color: Color(0xffCADBE4),
            fontSize: 32,
          ),
        ),
        backgroundColor: Color(0xff588297),
        actions: [
          PopupMenuButton(
            child: Icon(Icons.add,),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('Weekly Class'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Extra Class"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Meeting"),
              ),
            ],
            onSelected: (value) async {
              if (value == 1) {
                await getSubject(context);
                await selectDay();
                selectedDate =
                    firstDateOfWeek.add(Duration(days: (selectedDay - 1)));
                help = "From";
                from = await selectTime(context);
                initial = from;
                from_dt = new DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, from.hour, from.minute);
                help = "To";
                till = await selectTime(context);
                till_dt = new DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, till.hour, till.minute);
                initial = TimeOfDay(hour: 0, minute: 0);
                setState(() {
                  var ttHelper = TimetableDatabase.instance;

                  Timetable timetable = Timetable(
                    id: 0,
                    title: '$titleSubject $titleSubtitle',
                    startYear: from_dt.year,
                    startMonth: from_dt.month,
                    startDay: from_dt.day,
                    startHour: from_dt.hour,
                    startMinute: from_dt.minute,
                    endYear: till_dt.year,
                    endMonth: till_dt.month,
                    endDay: till_dt.day,
                    endHour: till.hour,
                    endMinute: till.minute,
                    interval: 7,
                  );
                  int i;
                  for (i = 0; i < timetableSubjectsList.length; i++) {
                    if (timetableSubjectsList[i] == titleSubject) break;
                  }
                  ttHelper.addTimetable(timetable);
                  meetings.add(Meeting(timetable.title, from_dt, till_dt,
                      colors[i], false, 'FREQ=DAILY;INTERVAL=7'));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TimeTable()));
                });
              } else if (value == 2) {
                await getSubject(context);
                await selectDate(context);
                help = "From";
                from = await selectTime(context);
                initial = from;
                from_dt = new DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, from.hour, from.minute);
                help = "To";
                till = await selectTime(context);
                till_dt = new DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, till.hour, till.minute);
                initial = TimeOfDay(hour: 0, minute: 0);
                setState(() {
                  var ttHelper = TimetableDatabase.instance;

                  Timetable timetable = Timetable(
                    id: 0,
                    title: '$titleSubject $titleSubtitle',
                    startYear: from_dt.year,
                    startMonth: from_dt.month,
                    startDay: from_dt.day,
                    startHour: from_dt.hour,
                    startMinute: from_dt.minute,
                    endYear: till_dt.year,
                    endMonth: till_dt.month,
                    endDay: till_dt.day,
                    endHour: till.hour,
                    endMinute: till.minute,
                    interval: 365,
                  );

                  ttHelper.addTimetable(timetable);
                  meetings.add(Meeting(timetable.title, from_dt, till_dt,
                      colors[0], false, 'FREQ=DAILY;INTERVAL=365'));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TimeTable()));
                });
              } else if (value == 3) {
                await getTitle(context);
                await selectDate(context);
                help = "From";
                from = await selectTime(context);
                initial = from;
                from_dt = new DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, from.hour, from.minute);
                help = "To";
                till = await selectTime(context);
                till_dt = new DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, till.hour, till.minute);
                initial = TimeOfDay(hour: 0, minute: 0);
                setState(() {
                  var ttHelper = TimetableDatabase.instance;

                  Timetable timetable = Timetable(
                    id: 0,
                    title: '$titleSubject $titleSubtitle',
                    startYear: from_dt.year,
                    startMonth: from_dt.month,
                    startDay: from_dt.day,
                    startHour: from_dt.hour,
                    startMinute: from_dt.minute,
                    endYear: till_dt.year,
                    endMonth: till_dt.month,
                    endDay: till_dt.day,
                    endHour: till.hour,
                    endMinute: till.minute,
                    interval: 365,
                  );

                  ttHelper.addTimetable(timetable);
                  meetings.add(Meeting(myController.text, from_dt, till_dt,
                      colors[0], false, 'FREQ=DAILY;INTERVAL=365'));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TimeTable()));
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              return alert(context,
                content: Container(
                  child: Text(
                    'Long press the appointment to delete',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: MeetingDataSource(_getDataSource()),
        onLongPress: deleteSelected,
        allowedViews: [
          CalendarView.week,
          CalendarView.day,
        ],
      ),
      drawer: Settings(),
      bottomNavigationBar: bottomAppBar(),
    );
  }

  List<Meeting> _getDataSource() {
    return meetings;
  }

  getSubject(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Subject'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        value: subject,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        onChanged: (String newValue) {
                          setState(() {
                            subject = newValue;
                            titleSubject = newValue.toString();
                          });
                        },
                        items: timetableSubjectsList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        value: subtitle,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Color(0xffE28F22),
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            subtitle = newValue;
                            titleSubtitle = newValue;
                          });
                          //_setSubject(newValue);
                        },
                        items: timetableSubtitlesList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Submit',
                            style: TextStyle(
                                color: Color(0xff235790), fontSize: 16)),
                      ),
                    ],
                  ),
                );
              }
          );
        }
        );
  }

  selectDay() {
    firstDateOfWeek = now.subtract(Duration(days: now.weekday - 1));
    print(firstDateOfWeek);
    final values = List.filled(7, true);
    return showDialog(
      context: context,
      builder: (context) {
        return WeekdaySelector(
          color: Color(0xff235790),
          fillColor: Color(0xff235790),
          selectedFillColor: Color(0xff235790),
          //textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          onChanged: (int day) {
            setState(() {
              selectedDay = day;
              final index = day % 7;
              values[index] = !values[index];
              Navigator.pop(context);
            });
          },
          values: values,
        );
      },
    );
  }

  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        helpText: help,
        initialTime: initial,
        builder: (BuildContext context, Widget child) {
          /*return MediaQuery(
                                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                                                    child: child,
                                                    );*/
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Color(0xff588297),
              accentColor: Color(0xffE28F22),
              colorScheme: ColorScheme.light(
                primary: Color(0xff235790),
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    return picked_s;
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xff588297),
            accentColor: Color(0xffE28F22),
            colorScheme: ColorScheme.light(
              primary: Color(0xff235790),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final myController = TextEditingController();
  getTitle(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Subject"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: myController,
                  decoration: InputDecoration(labelText: 'Subject'),
                  validator: (val) {
                    return val.isEmpty ? 'Enter the subject name' : null;
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        });
  }

  deleteSelected(CalendarLongPressDetails details) {
    final Meeting tappedEvent = details.appointments[0];

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${tappedEvent.eventName}?'),
            actions: [
              new TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => TimeTable()));
                  },
                  child: Text('Cancel')),
              new TextButton(
                child: new Text('Delete',
                    style: TextStyle(color: Color(0xff235790), fontSize: 16)),
                onPressed: () {
                  //customReminders.remove(customReminder);
                  meetings.remove(tappedEvent);
                  var ttHelper = TimetableDatabase.instance;
                  ttHelper.deleteTimetable(tappedEvent.eventName);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TimeTable()),
                  );
                },
              ),
            ],
          );
        });
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
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
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments[index].recurrenceRule;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.recurrenceRule);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String recurrenceRule;
}