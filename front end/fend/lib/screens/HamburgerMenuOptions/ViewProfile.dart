import 'dart:convert';

import 'package:fend/models/student_json.dart';
import 'package:fend/screens/HamburgerMenuOptions/AvatarChoice.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart';

class ViewProfile extends StatefulWidget {
  @override
  ViewProfileState createState() => ViewProfileState();
}

class ViewProfileState extends State<ViewProfile> {
  String name = '';
  String sid = '';
  String branch = '';
  String year = '';
  String semester = '';
  String clubs = '';
  String insta = '';

  @override
  void initState() {
    super.initState();
    updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle( color: Color(0xffCADBE4), fontSize: 28,),),
        backgroundColor: Color(0xff588297),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Card(
          margin: EdgeInsets.fromLTRB(15, 40, 15, 0),
          color: Color(0xffCADBE4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                  margin: EdgeInsets.only(top: 20, left: 20, bottom: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 5, color: Color(0xffE28F22)),
                  ),
                ),
                Text(
                  'SID',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  sid.toString(),
                  style: TextStyle(
                    color: Color(0xff588297),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\nBranch',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  branch,
                  style: TextStyle(
                    color: Color(0xff588297),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\nYear',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  year,
                  style: TextStyle(
                    color: Color(0xff588297),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\nSemester',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  semester,
                  style: TextStyle(
                    color: Color(0xff588297),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\nClubs',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  clubs + '\n',
                  style: TextStyle(
                    color: Color(0xff588297),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Container(
                          child: Image.asset('assets/instagram_logo.png'),
                          height: 25,
                        ),
                      ),
                      TextSpan(
                        text: ' ' + insta,
                        style: TextStyle(
                          color: Color(0xff588297),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProfile() async {
    var response =
        await get(Uri.parse('${global.url}/viewprofile/${global.sid}'));
    var profileData = Social.fromJson(json.decode(response.body));
    setState(() {
      name = profileData.name;
      sid = profileData.sid.toString();
      branch = profileData.branch;
      year = profileData.year.toString();
      semester = profileData.semester.toString();
      clubs = profileData.clubs.toString();
      insta = profileData.insta.toString() == 'null'
          ? 'no instagram handle'
          : profileData.insta;
    });
  }
}
