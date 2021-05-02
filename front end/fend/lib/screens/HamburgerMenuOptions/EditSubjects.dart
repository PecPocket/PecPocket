import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/screens/HamburgerMenuOptions/AddSubjects.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';

import '../HamburgerMenu.dart';

class EditSubjects extends StatefulWidget {
  String title;
  EditSubjects({this.title});

  @override
  _EditSubjectsState createState() => _EditSubjectsState();
}

List<String> currentSubjects = [];

class _EditSubjectsState extends State<EditSubjects> {
  String subtitle = 'YOUR SUBJECTS';

  @override
  Widget build(BuildContext context) {
    if(currentSubjects.length == 0) {
      setState(() {
        subtitle = 'CHOOSE YOUR SUBJECTS';
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xffCADBE4),
            fontSize: 32,
          ),
        ),
        backgroundColor: Color(0xff588297),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              return alert(context,
                content: Container(
                  child: Text(
                    'Long press the subject name to delete',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 30),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff235790),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: currentSubjects.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    var dbHelper = SubjectDatabase.instance;
                    dbHelper.deleteSubject(currentSubjects[index]);
                    setState(() {
                      currentSubjects.removeAt(index);
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.circle,
                                color: Color(0xff588297),
                              ),
                            ),
                            TextSpan(
                              text: '  ' + currentSubjects[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddSubjects()));
                });
              },
              child: Text('Add Subject'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Color(0xffE28F22); // Use the component's default.
                  },
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
