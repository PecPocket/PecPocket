import 'dart:convert';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/ClubsDB.dart';
import 'package:fend/classes/Clubs.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart' show get;

class SignUp3 extends StatefulWidget {
  createState() {
    return SignUp3State();
  }
}

class SignUp3State extends State<SignUp3> {
  String searchForClub;
  List<String> clubslist = [];
  List<String> selectedclubsList = [];
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add Clubs',
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
                      'Long press the club name to delete',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          child: Form(
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Enter Club Name',
                    ),
                    onChanged: (String value) {
                      setState(() {
                        searchForClub = value;
                        club();
                      });
                    },
                  ),
                  clubsList(context),
                  Container(
                    height: 25,
                  ),
                  Center(
                    child: Text(
                      'SELECTED CLUBS',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff235790),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  selectedClubsList(context),
                  confirmClubsButton(),
                ],
              )),
        ),
      ),
    );
  }

  club() async {
    var response =
    await get(Uri.parse('${global.url}/club/search?query=$searchForClub'));
    var rb = response.body;

    var list = json.decode(rb) as List;

    List<Clubs> myClubs = list.map((i) => Clubs.fromJson(i)).toList();

    setState(() {
      clubslist.clear();
      for (int i = 0; i < 5; i++) {
        clubslist.add(myClubs[i].club);
      }
    });
  }

  clubsList(context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedclubsList.add(clubslist[index]);
              });
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xffCADBE4),
                ),
                height: 30,
                child: Center(
                  child: Text(
                    clubslist[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff588297),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: clubslist.length,
      ),
    );
  }

  selectedClubsList(context) {
    return Container(
      height: 200,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              setState(() {
                selectedclubsList.removeAt(index);
              });
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(70, 15, 0, 0),
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
                        text: '  ' + selectedclubsList[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
            ),
          );
        },
        itemCount: selectedclubsList.length,
      ),
    );
  }

  confirmClubsButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
          onPressed: () {
            var clubHelper = ClubDatabase.instance;
            for (int i = 0; i < selectedclubsList.length; i++) {
              Club club = Club(id: 0, club: selectedclubsList[i]);
              clubHelper.addClub(club);
            }
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Color(0xffE28F22); // Use the component's default.
              },
            ),
          ),
          child: Text('Confirm Clubs')),
    );
  }
}