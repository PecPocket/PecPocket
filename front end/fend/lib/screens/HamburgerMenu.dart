import 'dart:convert';

import 'package:fend/Databases/AttendanceDB.dart';
import 'package:fend/Databases/ClubsDB.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/TimetableDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/classes/Clubs.dart';
import 'package:fend/classes/subjects.dart';
import 'package:fend/classes/user.dart';
import 'package:fend/screens/signUp/SignUpPassword.dart';
import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:fend/models/student_json.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'CustomFolder.dart';
import 'HamburgerMenuOptions/AvatarChoice.dart';
import 'HamburgerMenuOptions/EditSubjects.dart';
import 'HamburgerMenuOptions/UpdateClubs.dart';
import 'HamburgerMenuOptions/ViewProfile.dart';
import 'login_screen.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String name = "";
  String clubsOption = 'Add Clubs'; //Change to Edit clubs if clubs have been added already
  String subjectsOption = 'Add Subjects';
  String instagramHandle;

  @override
  void initState() {
    super.initState();
    getName();
    getClubStatus();
    getSubjectStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: ListView(
        children: [
          Container(
            height: 300,
            color: Color(0xffCADBE4),
            child: DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Color(0xff235790),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        child: Image.asset(selectedAvatar),
                        height: 105,
                        margin: EdgeInsets.only(top: 10, left: 20, bottom: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 5, color: Color(0xffE28F22)),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Change Avatar',
                          style: TextStyle(
                            color: Color(0xff235790),
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AvatarChoice()),
                          );
                        },
                      ),
                      TextButton(
                        child: Text(
                          'View Profile',
                          style: TextStyle(
                            color: Color(0xff235790),
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ViewProfile()));
                          });
                        },
                      ),
                    ],
                  ),
                )
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              'Custom Folder',
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomFolder()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              subjectsOption,
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              var subjectHelper = SubjectDatabase.instance;
              List<Subject> subjects = await subjectHelper.getAllSubjects();

              setState(() {
                if (currentSubjects.length == 0) {
                  for (int i = 0; i < subjects.length; i++) {
                    currentSubjects.add(subjects[i].subject);
                  }
                } else {
                  currentSubjects.clear();
                  if (currentSubjects.length == 0) {
                    for (int i = 0; i < subjects.length; i++) {
                      currentSubjects.add(subjects[i].subject);
                    }
                  }
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditSubjects(title: subjectsOption,)));
              });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              'Add/Update Instagram Handle',
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Enter Instagram Handle',
                        style: TextStyle(
                          color: Color(0xff235790),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (String value) {
                              instagramHandle = value;
                            },
                          ),
                          TextButton(
                              onPressed: () async {
                                var userHelper = UserDatabase.instance;
                                var userData = await userHelper.getAllUsers();
                                setState(() {
                                  var jsonMap = {
                                    'SID': userData[0].sid,
                                    'Insta': instagramHandle,
                                  };
                                  String jsonStr = jsonEncode(jsonMap);
                                  print(jsonMap);
                                  http.put(
                                    Uri.parse(
                                        '${global.url}/insta/${userData[0].sid}'),
                                    body: jsonStr,
                                    headers: {
                                      "Content-Type": "application/json"
                                    },
                                  );
                                  print('updated');
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                  'Confirm',
                                style: TextStyle(
                                  color: Color(0xffE28F22),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              clubsOption, //Change to Edit clubs if clubs have been added already
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              var clubHelper = ClubDatabase.instance;
              List<Club> clubs = await clubHelper.getAllClubs();
              setState(() {
                if (currentClubs.length == 0) {
                  for (int i = 0; i < clubs.length; i++) {
                    currentClubs.add(clubs[i].club);
                  }
                }
                else {
                  currentClubs.clear();
                  if (currentClubs.length == 0) {
                    for (int i = 0; i < clubs.length; i++) {
                      currentClubs.add(clubs[i].club);
                    }
                  }
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdateClubs(title: clubsOption,)));
              });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Enter New Password',
                        style: TextStyle(
                          color: Color(0xff235790),
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            obscureText: true,
                            onChanged: (String value) {
                              confirmPassword = value;
                            },
                          ),
                          TextButton(
                              onPressed: () async {
                                var userHelper = UserDatabase.instance;
                                var userData = await userHelper.getAllUsers();
                                setState(() {
                                  userHelper.deleteUser(userData[0].sid);
                                  User user = new User(
                                      id: 0,
                                      sid: userData[0].sid,
                                      password: confirmPassword,
                                      auth: userData[0].auth,
                                      login: 1);
                                  userHelper.addUser(user);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                  'Submit',
                                style: TextStyle(
                                  color: Color(0xffE28F22),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Do you want to Logout?',
                        style: TextStyle(
                          color: Color(0xff235790),
                        ),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                  'No',
                                style: TextStyle(
                                  color: Color(0xffE28F22),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                          TextButton(
                              onPressed: () async {
                                var userHelper = UserDatabase.instance;
                                var userData = await userHelper.getAllUsers();
                                setState(() {
                                  User user = new User(
                                      id: 0,
                                      sid: userData[0].sid,
                                      password: userData[0].password,
                                      auth: userData[0].auth,
                                      login: 0);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                });
                              },
                              child: Text(
                                  'Yes',
                                style: TextStyle(
                                  color: Color(0xffE28F22),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Color(0xffB2B0E1),
              size: 30,
            ),
            title: Text(
              'Delete Account',
              style: TextStyle(
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Delete Account?',
                        style: TextStyle(
                          color: Color(0xff235790),
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                            ),
                            onChanged: (String value) {
                              confirmPassword = value;
                            },
                          ),
                          TextButton(
                            onPressed: () async {
                              var userHelper = UserDatabase.instance;
                              var attendanceHelper =
                                  AttendanceDatabase.instance;
                              var clubHelper = ClubDatabase.instance;
                              var reminderHelper = ReminderDatabase.instance;
                              var subjectHelper = SubjectDatabase.instance;
                              var timetableHelper =
                                  TimetableDatabase.instance;
                              var userData = await userHelper.getAllUsers();
                              var attendanceData =
                              await attendanceHelper.getAllAttendance();
                              var clubData = await clubHelper.getAllClubs();
                              var reminderData =
                              await reminderHelper.getAllReminders();
                              var subjectData =
                              subjectHelper.getAllSubjects();
                              final http.Response response =
                              await http.delete(
                                Uri.parse(
                                    '${global.url}/delete/${userData[0].sid}'),
                                headers: <String, String>{
                                  'Content-Type':
                                  'application/json; charset=UTF-8',
                                },
                              );
                              print(response.body);
                              attendanceHelper.deleteTable();
                              clubHelper.deleteTable();
                              reminderHelper.deleteTable();
                              subjectHelper.deleteTable();
                              timetableHelper.deleteTable();
                              userHelper.deleteTable();

                              setState(() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp1()));
                              });
                            },
                              child: Text(
                                  'Confirm Password',
                                style: TextStyle(
                                  color: Color(0xffE28F22),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
  getName() async{
    var response =
        await get(Uri.parse('${global.url}/viewprofile/${global.sid}'));
    var profileData = Social.fromJson(json.decode(response.body));
    setState(() {
      name = profileData.name;
    });
  }

  getClubStatus() async{
    var clubHelper = ClubDatabase.instance;
    List<Club> clubs = await clubHelper.getAllClubs();
    if(clubs.length != 0) {
      clubsOption = 'Edit Clubs';
    }
  }

  getSubjectStatus() async{
    var subjectHelper = SubjectDatabase.instance;
    List<Subject> subjects = await subjectHelper.getAllSubjects();
    if(subjects.length != 0) {
      subjectsOption = 'Edit Subjects';
    }
  }
}
