import 'package:fend/Databases/AttendanceDB.dart';
import 'package:fend/classes/Attendances.dart';
import 'package:fend/models/subjectAttendanceDetails.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:fend/screens/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttendanceCard extends StatefulWidget {
  final SubjectAttendanceDetails subject;
  int index;

  AttendanceCard({this.subject, this.index});

  @override
  _AttendanceCardState createState() => _AttendanceCardState();
}

//List<int> colorChoices = [0xff7BA399, 0xffF07F83, 0XffFECE48, 0xffDE6A66, 0xff813CA3, 0xff9A275A, 0xffD97F30, 0xff484F70, 0xff2F3737, 0xff23356C];

class _AttendanceCardState extends State<AttendanceCard> {
  @override
  void initState() {
    setAttendanceStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = [
      ChartData('Attended', widget.subject.percentage, Color(0xffffffff)),
      ChartData('Not attended', (100 - widget.subject.percentage),
          Color(widget.subject.selectedColor))
    ];
    return Card(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 25),
      color: Color(widget.subject.selectedColor),
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 85,
                    width: 85,
                    child: Center(
                      child: SfCircularChart(
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Container(
                              child: Text(
                                (widget.subject.percentage.round()).toString() +
                                    "%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            dataSource: chartData,
                            pointColorMapper: (ChartData data, _) =>
                                data.chartColor,
                            xValueMapper: (ChartData data, _) => data.title,
                            yValueMapper: (ChartData data, _) => data.perc,
                            radius: '100%',
                            innerRadius: '85%',
                            opacity: 0.8,
                          ),
                        ],
                      ),
                    )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          var dbHelper = AttendanceDatabase.instance;

                          setState(() {
                            widget.subject.attended += 1;
                            widget.subject.total += 1;
                            widget.subject.percentage =
                                (widget.subject.attended /
                                        widget.subject.total) *
                                    100;
                            if (widget.subject.percentage == 100) {
                              widget.subject.percentage = 99.99;
                            }

                            var map = {
                              "id": 1,
                              "subject": widget.subject.subjectName,
                              "subtitle": widget.subject.subtitle,
                              "classesAttended": widget.subject.attended,
                              "totalClasses": widget.subject.total,
                            };

                            Attendances attendance = Attendances.fromJson(map);

                            dbHelper.deleteAttendance(
                                attendance.subject, attendance.subtitle);
                            dbHelper.addAttendance(attendance);
                            setAttendanceStatus();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          var dbHelper = AttendanceDatabase.instance;
                          setState(() {
                            widget.subject.total += 1;
                            widget.subject.percentage =
                                (widget.subject.attended /
                                        widget.subject.total) *
                                    100;
                            if (widget.subject.percentage == 100) {
                              widget.subject.percentage = 99.99;
                            } else if (widget.subject.attended == 0) {
                              widget.subject.percentage = 00.01;
                            }
                            var map = {
                              "id": 0,
                              "subject": widget.subject.subjectName,
                              "subtitle": widget.subject.subtitle,
                              "classesAttended": widget.subject.attended,
                              "totalClasses": widget.subject.total,
                            };

                            Attendances attendance = Attendances.fromJson(map);

                            dbHelper.deleteAttendance(
                                attendance.subject, attendance.subtitle);
                            dbHelper.addAttendance(attendance);
                            setAttendanceStatus();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: IconButton(
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    widget.subject.subjectName +
                                        " " +
                                        widget.subject.subtitle,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          editSelectedAttendanceCard();
                                        },
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Color(0xff235790),
                                              fontSize: 16),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteSelectedAttendanceCard();
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Color(0xff235790),
                                              fontSize: 16),
                                        )),
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              widget.subject.attended.toString() +
                  ' / ' +
                  widget.subject.total.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.subject.subjectName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.subject.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7,),
              child: Text(
                widget.subject.status,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  editSelectedAttendanceCard() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 25,
                  child: TextFormField(
                    initialValue: widget.subject.attended.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      widget.subject.attended = int.parse(value);
                    },
                  ),
                ),
                Text(" / "),
                Container(
                  width: 25,
                  child: TextFormField(
                    initialValue: widget.subject.total.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      widget.subject.total = int.parse(value);
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  var attendanceHelper = AttendanceDatabase.instance;
                  var map = {
                    "id": 0,
                    "subject": widget.subject.subjectName,
                    "subtitle": widget.subject.subtitle,
                    "classesAttended": widget.subject.attended,
                    "totalClasses": widget.subject.total,
                  };

                  Attendances attendance = Attendances.fromJson(map);

                  attendanceHelper.updateAttendance(attendance);
                  setState(() {
                    widget.subject.percentage =
                        (widget.subject.attended / widget.subject.total) * 100;
                    if (widget.subject.attended == 0) {
                      widget.subject.percentage = 00.01;
                    }
                    setAttendanceStatus();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Color(0xff235790), fontSize: 16),
                ),
              ),
            ],
          );
        });
  }

  deleteSelectedAttendanceCard() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Delete ${widget.subject.subjectName} ${widget.subject.subtitle}?'),
            actions: <Widget>[
              new TextButton(
                  child: new Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xff235790), fontSize: 16),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              new TextButton(
                child: new Text(
                  'Delete',
                  style: TextStyle(color: Color(0xff235790), fontSize: 16),
                ),
                onPressed: () {
                  var attendanceHelper = AttendanceDatabase.instance;

                  var map = {
                    "id": 0,
                    "subject": widget.subject.subjectName,
                    "subtitle": widget.subject.subtitle,
                    "classesAttended": widget.subject.attended,
                    "totalClasses": widget.subject.total,
                  };

                  Attendances attendance = Attendances.fromJson(map);

                  attendanceHelper.deleteAttendance(
                      attendance.subject, attendance.subtitle);
                  Navigator.of(context).pop();
                  subjects.remove(widget.subject);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Attendance()),
                  );
                },
              ),
            ],
          );
        });
  }

  setAttendanceStatus() {
    int canMiss = 0;
    int shouldAttend = 0;
    if (widget.subject.percentage >= 75) {
      widget.subject.status = "You are safe";
      canMiss =
          (((4 / 3) * widget.subject.attended) - widget.subject.total).toInt();
    }
    if (canMiss > 0) {
      widget.subject.status = "You can miss the next $canMiss classes";
    }
    if (widget.subject.percentage < 75) {
      shouldAttend = 3 * widget.subject.total - 4 * widget.subject.attended;
      widget.subject.status = "Don't miss the next $shouldAttend classes";
    }
  }
}

class ChartData {
  ChartData(this.title, this.perc, [this.chartColor]);
  final String title;
  final double perc;
  final Color chartColor;
}
