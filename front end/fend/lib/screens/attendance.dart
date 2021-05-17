import 'package:fend/Databases/AttendanceDB.dart';
import 'package:fend/classes/Attendances.dart';
import 'package:fend/models/subjectAttendanceDetails.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:fend/widgets/attendanceCard.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HamburgerMenu.dart';
import 'mainPage.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

List<SubjectAttendanceDetails> subjects = [];
List<String> subjectList = [];
List<String> subtitleList = ['Lecture', 'Tutorial', 'Lab'];
String subjectName;
String subtitle;
int selectedColor = 0xffE47A77;

void setSubject(context) async {
  var attendanceHelper = AttendanceDatabase.instance;
  var allAttendances = await attendanceHelper.getAllAttendance();
  var latestAttendanceId = allAttendances.length - 1;
  SubjectAttendanceDetails subjectAttendanceDetails =
      SubjectAttendanceDetails(subjectName, subtitle, selectedColor, 0, 0);
  subjects.add(subjectAttendanceDetails);
  print('HELLLLOOOO ${subjects[subjects.length - 1].percentage}');

  //add selectedColor to sqlite
  var map = {
    "id": latestAttendanceId,
    "subject": subjectName,
    "subtitle": subtitle,
    "classesAttended": 0,
    "totalClasses": 0,
  };
  Attendances attendances = Attendances.fromJson(map);
  attendanceHelper.addAttendance(attendances);
  subjectName = null;
  subtitle = null;
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Attendance()));
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  AnimationController animationController;
  bool isPlaying = false;
  var key = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return Scaffold(
        key: key,
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: AnimatedIcon(
              color: Colors.black,
              icon: AnimatedIcons.menu_close,
              progress: animationController,
            ),
            onPressed: () => handleOnPressed(),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            TextButton(
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GetSubject()));
              },
            ),
          ],
        ),
        drawer: Settings(),
        bottomNavigationBar: bottomAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                ),
                Image.asset(
                  'assets/attendance_placeholder.png',
                  height: 250,
                  width: 250,
                ),
                Text(
                  'Looks like you are not tracking your attendance yet. Click the + button to add a subject.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      key: key,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            color: Colors.black,
            icon: AnimatedIcons.menu_close,
            progress: animationController,
          ),
          onPressed: () => handleOnPressed(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GetSubject()));
            },
          ),
        ],
      ),
      drawer: Settings(),
      bottomNavigationBar: bottomAppBar(),
      body: ListView(
        scrollDirection: Axis.vertical,
        //shrinkWrap: true,
        children: [
          Container(
            //height: 40,
            padding: EdgeInsets.fromLTRB(25, 10, 25, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: subjects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (context, index) {
              return AttendanceCard(
                subject: subjects[index],
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }

  final myController = TextEditingController();

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

class GetSubject extends StatefulWidget {
  @override
  _GetSubjectState createState() => _GetSubjectState();
}

class _GetSubjectState extends State<GetSubject> {
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
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: AppBar(
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
        children: [
          Container(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            color: Color(0xff272727),
            child: Image.asset('assets/attendance.png'),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 330,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: subjectName,
                    hint: Text('Subject Name'),
                    itemHeight: 70,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 35,
                    elevation: 16,
                    //style: TextStyle(fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Color(0xff0B7A75),
                    ),
                    isExpanded: true,
                    onChanged: (String newValue) {
                      setState(() {
                        print("Changed");
                        subjectName = newValue;
                      });
                    },
                    items: subjectList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: subtitle,
                    hint: Text('Type'),
                    itemHeight: 70,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 35,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Color(0xff0B7A75),
                    ),
                    isExpanded: true,
                    onChanged: (String newValue) {
                      setState(() {
                        subtitle = newValue;
                      });
                    },
                    items: subtitleList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                      setSubject(context);
                    },
                    child: Text('Add Attendance'),
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
          ),
        ],
      ),
    );
  }

  resetIconSize() {
    colorIconSize = [24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24];
  }
}
