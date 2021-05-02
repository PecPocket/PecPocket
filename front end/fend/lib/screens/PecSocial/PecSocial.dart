import 'dart:convert';
import 'dart:math';
import 'package:fend/models/student_json.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:fend/globals.dart' as global;

import '../HamburgerMenu.dart';

List<String> socialListName = [];
List<int> socialListSid = [];
List<String> socialListBranch = [];
List<int> socialListYear = [];
List<int> socialListSemester = [];
List<String> socialListInsta = [];
List<dynamic> socialListClubs = [];

class PecSocial extends StatefulWidget {
  @override
  PecSocialState createState() => PecSocialState();
}

class PecSocialState extends State<PecSocial> {
  String searchFor;
  Random random = new Random();
  int randomNumber;
  List<String> images = [
    'assets/001-woman.png',
    'assets/002-man.png',
    'assets/003-woman.png',
    'assets/004-woman.png',
    'assets/005-man.png',
    'assets/006-woman.png',
    'assets/007-woman.png',
    'assets/008-woman.png',
    'assets/009-woman.png',
    'assets/010-woman.png',
    'assets/011-man.png',
    'assets/012-woman.png',
    'assets/013-man.png',
    'assets/014-man.png',
    'assets/015-woman.png',
    'assets/016-woman.png',
    'assets/017-woman.png',
    'assets/018-woman.png',
    'assets/019-man.png',
    'assets/020-man.png',
    'assets/021-man.png',
    'assets/022-woman.png',
    'assets/023-woman.png',
    'assets/024-man.png',
    'assets/025-woman.png',
    'assets/026-man.png',
    'assets/027-woman.png',
    'assets/028-woman.png',
    'assets/029-man.png',
    'assets/030-woman.png',
    'assets/031-woman.png',
    'assets/032-man.png',
    'assets/033-woman.png',
    'assets/034-man.png',
    'assets/035-woman.png',
    'assets/036-man.png',
    'assets/037-woman.png',
    'assets/038-man.png',
    'assets/039-woman.png',
    'assets/040-woman.png',
    'assets/041-man.png',
    'assets/042-woman.png',
    'assets/043-woman.png',
    'assets/044-woman.png',
    'assets/045-woman.png',
    'assets/046-woman.png',
    'assets/047-woman.png',
    'assets/048-woman.png',
    'assets/049-man.png',
    'assets/050-woman.png',
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PEC Social',
          style: TextStyle(
            color: Color(0xffCADBE4),
            fontSize: 32,
          ),
        ),
        backgroundColor: Color(0xff588297),
      ),
      drawer: Settings(),
      bottomNavigationBar: bottomAppBar(),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Search here',
                ),
                onChanged: (String value) {
                  setState(() {
                    searchFor = value;
                    search();
                  });
                },
              ),
            ),
            studentsList(context),
          ],
        ),
      ),
    );
  }

  search() async {
    var response =
    await get(Uri.parse('${global.url}/social?query=$searchFor'));
    SocialList studentList = SocialList.fromJson(json.decode(response.body));
    setState(() {
      socialListName.clear();
      socialListSid.clear();
      socialListBranch.clear();
      socialListYear.clear();
      socialListSemester.clear();
      socialListInsta.clear();
      socialListClubs.clear();
      //socialListClubs.clear();
      for (int i = 0; i < studentList.social.length; i++) {
        socialListName.add(studentList.social[i].name);
        socialListSid.add(studentList.social[i].sid);
        socialListBranch.add(studentList.social[i].branch);
        socialListYear.add(studentList.social[i].year);
        socialListSemester.add(studentList.social[i].semester);
        socialListInsta.add(studentList.social[i].insta);
        socialListClubs.add(studentList.social[i].clubs);
        //socialListClubs.add(studentList.social[i].clubs);
      }
    });
  }

  studentsList(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
        child: Container(
          height: 80,
          color: Color(0xffCADBE4),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            //shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  randomNumber = random.nextInt(50);
                  setState(() {
                    studentProfile(context, index);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            socialListName[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff235790),
                            ),
                          ),
                          Text(
                            socialListSid[index].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff235790),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: socialListName.length,
          ),
        ),
      ),
    );
  }

  studentProfile(context, index) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                child: Image.asset(images[randomNumber]),
                height: 105,
                margin: EdgeInsets.only(top: 10, left: 20, bottom: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 5, color: Color(0xffE28F22)),
                ),
              ),
            ),
            Center(
              child: Text(
                '\n' + socialListName[index],
                style: TextStyle(
                  color: Color(0xff235790),
                  fontSize: 25,
                  fontWeight: FontWeight.w600),),
            ),
            Text(
              '\nSID',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              socialListSid[index].toString(),
              style: TextStyle(
                color: Color(0xff588297),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\nBranch',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              socialListBranch[index],
              style: TextStyle(
                color: Color(0xff588297),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\nYear',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              socialListYear[index].toString(),
              style: TextStyle(
                color: Color(0xff588297),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\nSemester',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              socialListSemester[index].toString(),
              style: TextStyle(
                color: Color(0xff588297),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\nClubs',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              //socialListClubs[index].toString().substring(min(1, socialListClubs[index].length), max(1, socialListClubs[index].length - 1)),
              socialListClubs[index].toString() + '\n',
              style: TextStyle(
                color: Color(0xff588297),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            socialListInsta[index] == null
                ? RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Container(
                      child: Image.asset('assets/instagram_logo.png'),
                      height: 25,
                    ),
                  ),
                  TextSpan(
                      text: ' Not available',
                    style: TextStyle(
                      color: Color(0xff588297),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
                : RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Container(
                      child: Image.asset('assets/instagram_logo.png'),
                      height: 25,
                    ),
                  ),
                  TextSpan(
                    text: ' ${socialListInsta[index]}',
                    style: TextStyle(
                      color: Color(0xff588297),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
