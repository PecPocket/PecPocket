import 'package:fend/Databases/TimetableDB.dart';
import 'package:fend/classes/Timetable.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'HamburgerMenu.dart';
import 'StudyMaterial/StudyMaterial0.dart';
import 'mainPage.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key key}) : super(key: key);
  @override
  _TimeTableState createState() => _TimeTableState();
}

List<Meeting> meetings = <Meeting>[];

List<String> timetableSubjectsList = [];
List<String> timetableSubtitlesList = ['Lecture', 'Tutorial', 'Lab'];
String selectedOption = 'Weekly Class';
String subject;
String subtitle;
DateTime now = new DateTime.now();
DateTime firstDateOfWeek;
int selectedDay = -1;
DateTime selectedDate = new DateTime.now();
String help;
String title;
TimeOfDay initial = TimeOfDay(hour: 0, minute: 0);
TimeOfDay from;
TimeOfDay till;
DateTime from_dt;
DateTime till_dt;
String titleSubject;
String titleSubtitle;
int selectedColor = 0xffE47A77;

class _TimeTableState extends State<TimeTable> with TickerProviderStateMixin {
  AnimationController animationController;
  bool isPlaying = false;
  var key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: AnimatedIcon(
            color: Colors.black,
            icon: AnimatedIcons.menu_close,
            progress: animationController,
          ),
          onPressed: () => handleOnPressed(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeTableInput(),
                    ));
              }),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        'Long press the appointment to delete',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Ok',
                            style: TextStyle(
                              color: Color(0xff588297),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.home_filled,
          color: Colors.white,
          size: 35,
        ),
        onPressed: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SfCalendarTheme(
        data: SfCalendarThemeData(
          todayHighlightColor: Color(0xff272727),
        ),
        child: SfCalendar(
          view: CalendarView.week,
          dataSource: MeetingDataSource(_getDataSource()),
          onLongPress: deleteSelected,
          allowedViews: [
            CalendarView.week,
            CalendarView.day,
          ],
          /*timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 7,
            endHour: 20,
            timeIntervalHeight: 45,
          ),*/
        ),
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
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Subject'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: subject,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    isExpanded: true,
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
                        style:
                            TextStyle(color: Color(0xff235790), fontSize: 16)),
                  ),
                ],
              ),
            );
          });
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

  handleOnPressed() async {
    if (!isPlaying) {
      await animationController.forward();
      key.currentState?.openDrawer();
      animationController.reverse();
    }
    setState(() {
      print(isPlaying);
    });
  }
}

class TimeTableInput extends StatefulWidget {
  @override
  _TimeTableInputState createState() => _TimeTableInputState();
}

class _TimeTableInputState extends State<TimeTableInput> {
  final myController = TextEditingController();
  List<double> colorIconSize = [
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24
  ];

  @override
  Widget build(BuildContext context) {
    firstDateOfWeek = now.subtract(Duration(days: now.weekday - 1));
    print(firstDateOfWeek);
    final values = List.filled(7, true);

    if (selectedOption == 'Extra Class') {
      return Scaffold(
        backgroundColor: Color(0xff272727),
        appBar: AppBar(
          title: Text(
            'Extra Class',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff272727),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 225,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
              color: Color(0xff272727),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'Weekly Class';
                          });
                        },
                        child: Text('Weekly Class'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'Extra Class';
                          });
                        },
                        child: Text('Extra Class'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'Personal';
                          });
                        },
                        child: Text('Personal'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth:
                        (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.grey,
                    ),
                    child: DropdownButton<String>(
                      value: subject,
                      hint: Text(
                        'Subject Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      itemHeight: 60,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0x95ffffff),
                      ),
                      iconSize: 35,
                      elevation: 16,
                      //style: TextStyle(fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Color(0x95ffffff),
                      ),
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          print("Changed");
                          subject = newValue;
                        });
                      },
                      items: timetableSubjectsList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.grey,
                    ),
                    child: DropdownButton<String>(
                      value: subtitle,
                      hint: Text(
                        'Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      itemHeight: 60,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0x95ffffff),
                      ),
                      iconSize: 35,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Color(0x95ffffff),
                      ),
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          subtitle = newValue;
                        });
                      },
                      items: timetableSubtitlesList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 305,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate(selectedDate),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          selectedDate = await _selectDate(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.calendar_today_rounded),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From: ' + formattedTime(from),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          help = "From";
                          from = await _selectTime(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.timer),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To: ' + formattedTimeEnd(till),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          help = "To";
                          till = await _selectTime(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.timer),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 7),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      children: List.generate(colorChoices.length, (index) {
                        return Center(
                          child: IconButton(
                            onPressed: () {
                              selectedColor = colorChoices[index];
                              setState(() {
                                resetIconSize();
                                colorIconSize[index] = 34;
                              });
                            },
                            icon: Icon(Icons.circle),
                            iconSize: colorIconSize[index],
                            color: Color(colorChoices[index]),
                          ),
                        );
                      }),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      from_dt = new DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          from.hour,
                          from.minute);
                      till_dt = new DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          till.hour,
                          till.minute);
                      setState(() {
                        var ttHelper = TimetableDatabase.instance;

                        Timetable timetable = Timetable(
                          id: 0,
                          title: '$subject $subtitle',
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
                            Color(selectedColor), false, ''));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeTable()));
                      });
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff272727),
                      minimumSize: Size(MediaQuery.of(context).size.width, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else if (selectedOption == 'Personal') {
      return Scaffold(
        backgroundColor: Color(0xff272727),
        appBar: AppBar(
          title: Text(
            'Personal',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff272727),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 225,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
              color: Color(0xff272727),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'Weekly Class';
                          });
                        },
                        child: Text('Weekly Class'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'Extra Class';
                          });
                        },
                        child: Text('Extra Class'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = 'Personal';
                          });
                        },
                        child: Text('Personal'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth:
                        (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                  TextFormField(
                    controller: myController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'TITLE',
                      labelStyle: TextStyle(
                        color: Color(0x95ffffff),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    validator: (val) {
                      return val.isEmpty ? 'Enter the title of the task' : null;
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 305,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate(selectedDate),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          selectedDate = await _selectDate(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.calendar_today_rounded),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From: ' + formattedTime(from),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          help = 'From';
                          from = await _selectTime(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.timer),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To: ' + formattedTimeEnd(till),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          help = 'To';
                          till = await _selectTime(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.timer),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 7),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      children: List.generate(colorChoices.length, (index) {
                        return Center(
                          child: IconButton(
                            onPressed: () {
                              selectedColor = colorChoices[index];
                              setState(() {
                                resetIconSize();
                                colorIconSize[index] = 34;
                              });
                            },
                            icon: Icon(Icons.circle),
                            iconSize: colorIconSize[index],
                            color: Color(colorChoices[index]),
                          ),
                        );
                      }),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      from_dt = new DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          from.hour,
                          from.minute);
                      till_dt = new DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          till.hour,
                          till.minute);
                      setState(() {
                        var ttHelper = TimetableDatabase.instance;

                        Timetable timetable = Timetable(
                          id: 0,
                          title: myController.text,
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
                        meetings.add(Meeting(myController.text, from_dt,
                            till_dt, Color(selectedColor), false, ''));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeTable()));
                      });
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff272727),
                      minimumSize: Size(MediaQuery.of(context).size.width, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
    //in case of weekly class
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: AppBar(
        title: Text(
          'Weekly Class',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff272727),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 230,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            color: Color(0xff272727),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Weekly Class';
                        });
                      },
                      child: Text('Weekly Class'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Extra Class';
                        });
                      },
                      child: Text('Extra Class'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Personal';
                        });
                      },
                      child: Text('Personal'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                  alignment: MainAxisAlignment.spaceEvenly,
                  buttonMinWidth: (MediaQuery.of(context).size.width / 3) - 10,
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.grey,
                  ),
                  child: DropdownButton<String>(
                    value: subject,
                    hint: Text(
                      'Subject Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    itemHeight: 60,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0x95ffffff),
                    ),
                    iconSize: 35,
                    elevation: 16,
                    //style: TextStyle(fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Color(0x95ffffff),
                    ),
                    isExpanded: true,
                    onChanged: (String newValue) {
                      setState(() {
                        print("Changed");
                        subject = newValue;
                      });
                    },
                    items: timetableSubjectsList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.grey,
                  ),
                  child: DropdownButton<String>(
                    value: subtitle,
                    hint: Text(
                      'Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    itemHeight: 60,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0x95ffffff),
                    ),
                    iconSize: 35,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Color(0x95ffffff),
                    ),
                    isExpanded: true,
                    onChanged: (String newValue) {
                      setState(() {
                        subtitle = newValue;
                      });
                    },
                    items: timetableSubtitlesList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 305,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                    ),
                    child: Text(
                      'Day: ' + dayToString(selectedDay),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                WeekdaySelector(
                  selectedFillColor: Color(0xff272727),
                  fillColor: Colors.white,
                  //textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  elevation: 10,
                  onChanged: (int day) {
                    setState(() {
                      selectedDay = day;
                      int index = day % 7;
                      values[index] = !values[index];
                      print(values);
                    });
                  },
                  values: values,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From: ' + formattedTime(from),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        help = "From";
                        from = await _selectTime(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.timer),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'To: ' + formattedTimeEnd(till),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        help = "To";
                        till = await _selectTime(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.timer),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 7),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 7,
                    children: List.generate(colorChoices.length, (index) {
                      return Center(
                        child: IconButton(
                          onPressed: () {
                            selectedColor = colorChoices[index];
                            setState(() {
                              resetIconSize();
                              colorIconSize[index] = 34;
                            });
                          },
                          icon: Icon(Icons.circle),
                          iconSize: colorIconSize[index],
                          color: Color(colorChoices[index]),
                        ),
                      );
                    }),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedDate =
                        firstDateOfWeek.add(Duration(days: (selectedDay - 1)));
                    from_dt = new DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        from.hour,
                        from.minute);
                    till_dt = new DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        till.hour,
                        till.minute);
                    setState(() {
                      var ttHelper = TimetableDatabase.instance;

                      Timetable timetable = Timetable(
                        id: 0,
                        title: '$subject $subtitle',
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
                      meetings.add(Meeting(
                          timetable.title,
                          from_dt,
                          till_dt,
                          Color(selectedColor),
                          false,
                          'FREQ=DAILY;INTERVAL=7'));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => TimeTable()));
                    });
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff272727),
                    minimumSize: Size(MediaQuery.of(context).size.width, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff272727),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return pickedDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    TimeOfDay initial = TimeOfDay.now();
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        helpText: help,
        initialTime: initial,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xff272727),
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    return pickedTime;
  }

  dayToString(int dayIndex) {
    if (dayIndex == 1) return "Monday";
    if (dayIndex == 2) return "Tuesday";
    if (dayIndex == 3) return "Wednesday";
    if (dayIndex == 4) return "Thursday";
    if (dayIndex == 5) return "Friday";
    if (dayIndex == 6) return "Saturday";
    if (dayIndex == 7) return "Sunday";
    if (dayIndex == -1) return "Select Day";
  }

  String formattedDate(DateTime date) {
    if (date == null) {
      return 'Select Date';
    }
    return DateFormat("EEEE, d MMMM").format(date);
  }

  String formattedTime(TimeOfDay time) {
    if (time == null) {
      return 'Select Start Time';
    }
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time);
  }

  String formattedTimeEnd(TimeOfDay time) {
    if (time == null) {
      return 'Select End Time';
    }
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time);
  }

  resetIconSize() {
    colorIconSize = [24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24];
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
