import 'dart:convert';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/classes/subjects.dart';
import 'package:fend/globals.dart' as global;
import 'package:fend/models/SubjectCodes.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/HamburgerMenu.dart';
import 'package:fend/screens/HamburgerMenuOptions/AddClubs.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:fend/screens/signUp/SignUpClubs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:math';

class SignUpSubjects extends StatefulWidget {
  @override
  createState() => SignUpSubjectsState();
}

List<String> selectedSubsList = [];
List<String> selectedCodesList = [];

class SignUpSubjectsState extends State<SignUpSubjects> {
  String searchForSubject;

  List<String> subsList = [];

  List<String> codesList = [];

  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
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
                          'Long press the subject name to delete',
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Form(
            child: ListView(
              children: [
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Enter Subject Name',
                      hintStyle: GoogleFonts.exo2(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        searchForSubject = value;
                        subject();
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                //dropDownList(),
                searchForSubject == null || searchForSubject.length == 0
                    ? Container(
                        height: 280,
                        child: Image(
                          image: AssetImage('assets/custom_reminders.png'),
                        ),
                      )
                    : subjectsList(context),
                SizedBox(height: 20),
                Text(
                  'Your Subjects',
                  style: GoogleFonts.exo2(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                selectedSubjectsList(context),
                SizedBox(height: 20),
                confirmSubjectsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  subject() async {
    var response = await get(
        Uri.parse('${global.url}/subject/search?query=$searchForSubject'));
    var mySubjects = CodesList.fromJson(json.decode(response.body));

    setState(() {
      subsList.clear();
      codesList.clear();
      for (int i = 0; i < mySubjects.codes.length; i++) {
        subsList.add(mySubjects.codes[i].subjectName);
        codesList.add(mySubjects.codes[i].subCode);
      }
    });
  }

  subjectsList(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 410,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        //shrinkWrap: true,
        itemBuilder: (context, index) {
          if (searchForSubject.length == 0) {
            subsList.clear();
            codesList.clear();
          }
          return GestureDetector(
            onTap: () {
              setState(() {
                int flag = 0;
                for (int i = 0; i < selectedSubsList.length; i++) {
                  if (subsList[index] == selectedSubsList[i]) {
                    flag = 1;
                    break;
                  }
                }
                if (flag == 0) {
                  selectedSubsList.insert(0, subsList[index]);
                  selectedCodesList.insert(0, codesList[index]);
                } else
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${subsList[index]} already added')));
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 350,
                  height: 65,
                  padding: EdgeInsets.only(left: 10, top: 7, right: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(1, 1)),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subsList[index],
                        style: GoogleFonts.exo2(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        codesList[index],
                        style: GoogleFonts.exo2(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
        itemCount: subsList.length,
      ),
    );
  }

  selectedSubjectsList(context) {
    return Container(
      height: 120,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            children: [
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    selectedSubsList.removeAt(index);
                    selectedCodesList.removeAt(index);
                  });
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Color(colorChoices[index]),
                    ),
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              selectedSubsList[index],
                              style: GoogleFonts.exo2(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              selectedCodesList[index],
                              style: GoogleFonts.exo2(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10)
            ],
          );
        },
        itemCount: selectedSubsList.length,
      ),
    );
  }

  confirmSubjectsButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          var subjectHelper = SubjectDatabase.instance;
          var databaseSubjects = await subjectHelper.getAllSubjects();
          int initialSubjectsLength = databaseSubjects.length;
          for (int i = 0;
              i < selectedSubsList.length - initialSubjectsLength;
              i++) {
            Subject subject = Subject(id: i, subject: selectedSubsList[i]);
            subjectHelper.addSubject(subject);
          }

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpClubs()));
        },
        child: Text('Confirm Subjects',
            style: GoogleFonts.exo2(
              fontWeight: FontWeight.bold,
            )),
        style: ElevatedButton.styleFrom(
          primary: Color(0xff272727),
          minimumSize: Size(MediaQuery.of(context).size.width, 45),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20)),
        ),
      ),
    );
  }

  int getRandomElement(List<int> colorChoices) {
    final random = new Random();
    var i = random.nextInt(colorChoices.length);
    return colorChoices[i];
  }
}
