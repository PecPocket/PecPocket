import 'dart:async';
import 'dart:convert';
import 'package:fend/Databases/AttendanceDB.dart';
import 'package:fend/Databases/AvatarDB.dart';
import 'package:fend/Databases/ClubsDB.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/TimetableDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/Databases/remindersDB.dart';
import 'package:fend/EntryPoint.dart';
import 'package:fend/classes/Clubs.dart';
import 'package:fend/classes/subjects.dart';
import 'package:fend/classes/user.dart';
import 'package:fend/screens/signUp/SignUpPassword.dart';
import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:fend/models/student_json.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'CustomFolder.dart';
import 'DevelopersPage.dart';
import 'HamburgerMenuOptions/AddClubs.dart';
import 'HamburgerMenuOptions/AddSubjects.dart';
import 'login_screen.dart';
import 'mainPage.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String name = "";
  String clubsOption =
      'Add Clubs'; //Change to Edit clubs if clubs have been added already
  String subjectsOption = 'Add Subjects';
  String instagramHandle;
  String newPassword = '';
  String pwdError;
  bool igUpdated = false;
  bool pwdUpdated = false;
  bool logoutDone = false;
  bool deleteDone = false;

  @override
  void initState() {
    super.initState();
    getName();
    getClubStatus();
    getSubjectStatus();
    getAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: Container(
        color: Color(0xff272727),
        child: ListView(
          children: [
            SizedBox(height: 100),
            Row(
              children: [
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/subjects.png'),
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    var subjectHelper = SubjectDatabase.instance;
                    List<Subject> subjects =
                        await subjectHelper.getAllSubjects();
                    selectedSubsList.clear();
                    selectedCodesList.clear();
                    for (int i = 0; i < subjects.length; i++) {
                      selectedSubsList.add(subjects[i].subject);
                      selectedCodesList.add('');
                    }
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSubjects()));
                    });
                  },
                  child: Text(
                    subjectsOption,
                    style: GoogleFonts.exo2(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/instagram.png'),
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                GestureDetector(
                  child: Text(
                    'Update Insta Handle',
                    style: GoogleFonts.exo2(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                igUpdated
                                    ? 'Instagram Handle Updated!'
                                    : 'Enter Instagram Handle',
                                style: TextStyle(
                                  color: Color(
                                    igUpdated ? 0xff0B7A75 : 0xff272727,
                                  ),
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
                                      var userData =
                                          await userHelper.getAllUsers();
                                      var jsonMap = {
                                        'SID': userData[0].sid.toString(),
                                        'Insta': instagramHandle,
                                      };
                                      String jsonStr = jsonEncode(jsonMap);
                                      var response = await http.put(
                                        Uri.parse(
                                            '${global.url}insta/${userData[0].sid}'),
                                        body: jsonStr,
                                        headers: {
                                          "Content-Type": "application/json"
                                        },
                                      );
                                      setState(() {
                                        igUpdated = true;
                                        print(response.body);
                                        Timer(Duration(seconds: 3), () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EntryPoint()));
                                        });
                                      });
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Color(0xff0B7A75),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/clubs.png'),
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    var clubHelper = ClubDatabase.instance;
                    List<Club> clubs = await clubHelper.getAllClubs();
                    selectedclubsList.clear();
                    for (int i = 0; i < clubs.length; i++) {
                      selectedclubsList.add(clubs[i].club);
                    }
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddClubs(
                                    title: clubsOption,
                                  )));
                    });
                  },
                  child: Text(
                    clubsOption,
                    style: GoogleFonts.exo2(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/password.png'),
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                pwdUpdated
                                    ? 'Password Changed!'
                                    : 'Change Password',
                                style: TextStyle(
                                  color: Color(
                                    pwdUpdated ? 0xff0B7A75 : 0xff272727,
                                  ),
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Current Password',
                                      errorText: pwdError,
                                    ),
                                    obscureText: true,
                                    onChanged: (String value) {
                                      pwdError = null;
                                      confirmPassword = value;
                                    },
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'New Password',
                                    ),
                                    obscureText: true,
                                    onChanged: (String value) {
                                      newPassword = value;
                                    },
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        var userHelper = UserDatabase.instance;
                                        var userData =
                                            await userHelper.getAllUsers();
                                        setState(() {
                                          if (userData[0].password ==
                                              confirmPassword) {
                                            userHelper.deleteTable();
                                            User user = new User(
                                                id: 0,
                                                sid: userData[0].sid,
                                                password: newPassword,
                                                auth: userData[0].auth,
                                                login: 1);
                                            userHelper.addUser(user);
                                            pwdUpdated = true;
                                            Timer(Duration(seconds: 3), () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          EntryPoint()));
                                            });
                                            //Navigator.pop(context);
                                          } else {
                                            pwdError = "Does not match records";
                                          }
                                        });
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Color(0xff0B7A75),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))
                                ],
                              ),
                            );
                          });
                        });
                  },
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.exo2(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(height: 400),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DevelopersPage()));
              },
              child: Row(
                children: [
                  SizedBox(width: 5),
                  IconButton(
                      icon: Icon(Icons.apps, color: Colors.white),
                      onPressed: () {}),
                  Text('Developers',
                      style:
                          GoogleFonts.exo2(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/logout.png'),
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                logoutDone
                                    ? 'Logging Out'
                                    : 'Do you want to Logout?',
                                style: TextStyle(
                                  color: Color(
                                    logoutDone ? 0xff0B7A75 : 0xff272727,
                                  ),
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
                                        color: Color(0xff0B7A75),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var userHelper = UserDatabase.instance;
                                      var userData =
                                          await userHelper.getAllUsers();
                                      setState(() {
                                        User user = new User(
                                            id: 0,
                                            sid: userData[0].sid,
                                            password: userData[0].password,
                                            auth: userData[0].auth,
                                            login: 0);
                                        logoutDone = true;
                                        Timer(Duration(seconds: 3), () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Login()));
                                        });
                                      });
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Color(0xff0B7A75),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.exo2(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/delete.png'),
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                deleteDone
                                    ? 'Deleting account'
                                    : 'Delete Account?',
                                style: TextStyle(
                                  color: Color(
                                    deleteDone ? 0xff0B7A75 : 0xff272727,
                                  ),
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
                                      var avatarHelper =
                                          AvatarDatabase.instance;
                                      var userHelper = UserDatabase.instance;
                                      var databaseUser =
                                          await userHelper.getAllUsers();
                                      var attendanceHelper =
                                          AttendanceDatabase.instance;
                                      var clubHelper = ClubDatabase.instance;
                                      var reminderHelper =
                                          ReminderDatabase.instance;
                                      var subjectHelper =
                                          SubjectDatabase.instance;
                                      var timetableHelper =
                                          TimetableDatabase.instance;
                                      var userData =
                                          await userHelper.getAllUsers();
                                      var attendanceData =
                                          await attendanceHelper
                                              .getAllAttendance();
                                      var clubData =
                                          await clubHelper.getAllClubs();
                                      var reminderData = await reminderHelper
                                          .getAllReminders();
                                      var subjectData =
                                          subjectHelper.getAllSubjects();

                                      if (confirmPassword ==
                                          databaseUser[0].password) {
                                        final http.Response response =
                                            await http.delete(
                                          Uri.parse(
                                              '${global.url}/delete/${userData[0].sid}'),
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                        );
                                        avatarHelper.deleteTable();
                                        attendanceHelper.deleteTable();
                                        clubHelper.deleteTable();
                                        reminderHelper.deleteTable();
                                        subjectHelper.deleteTable();
                                        timetableHelper.deleteTable();
                                        userHelper.deleteTable();

                                        setState(() {
                                          deleteDone = true;
                                          Timer(Duration(seconds: 3), () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => SignUp()));
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Confirm Password',
                                      style: TextStyle(
                                        color: Color(0xff0B7A75),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                  child: Text(
                    'Delete Account',
                    style: GoogleFonts.exo2(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  getName() async {
    var userHelper = UserDatabase.instance;
    var databaseUser = await userHelper.getAllUsers();
    var response = await get(
        Uri.parse('${global.url}/viewprofile/${databaseUser[0].sid}'));
    var profileData = Social.fromJson(json.decode(response.body));
    setState(() {
      name = profileData.name;
    });
  }

  getClubStatus() async {
    var clubHelper = ClubDatabase.instance;
    List<Club> clubs = await clubHelper.getAllClubs();
    if (clubs.length != 0) {
      clubsOption = 'Edit Clubs';
    }
  }

  getSubjectStatus() async {
    var subjectHelper = SubjectDatabase.instance;
    List<Subject> subjects = await subjectHelper.getAllSubjects();
    if (subjects.length != 0) {
      subjectsOption = 'Edit Subjects';
    }
  }

  void getAvatar() async {
    var avatarHelper = AvatarDatabase.instance;
    var databaseAvatar = await avatarHelper.getAllavatar();
  }
}
