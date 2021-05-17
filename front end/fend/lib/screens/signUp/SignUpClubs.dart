import 'dart:convert';
import 'dart:math';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/ClubsDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/EntryPoint.dart';
import 'package:fend/classes/Clubs.dart';
import 'package:fend/models/Club.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' show Response, get, post;
import 'package:http/http.dart' as http;

class SignUpClubs extends StatefulWidget {
  String title;
  SignUpClubs({this.title});

  createState() {
    return SignUpClubsState();
  }
}

List<String> clubslist = [];
List<String> clubCodesList = [];
List<String> selectedclubsList = [];
List<String> selectedclubCodesList = [];

class SignUpClubsState extends State<SignUpClubs> {
  String searchForClub;

  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
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
                          'Long press the club name to delete',
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
        resizeToAvoidBottomInset: false,
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
                    hintText: 'Enter Club Name',
                  ),
                  onChanged: (String value) {
                    setState(() {
                      searchForClub = value;
                      club();
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              //dropDownList(),
              searchForClub == null || searchForClub.length == 0
                  ? Container(
                      height: 280,
                      child: Image(
                        image: AssetImage('assets/custom_reminders.png'),
                      ),
                    )
                  : clubsList(context),
              SizedBox(height: 20),
              Text(
                'Your Clubs',
                style: GoogleFonts.exo2(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
              selectedClubsList(context),
              SizedBox(height: 20),
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

    if (searchForClub.length == 0) {
      setState(() {
        clubslist.clear();
        clubCodesList.clear();
      });
    } else {
      setState(() {
        clubslist.clear();
        clubCodesList.clear();
        for (int i = 0; i < myClubs.length; i++) {
          clubslist.add(myClubs[i].club);
          clubCodesList.add(myClubs[i].clubCode);
        }
      });
    }
  }

  clubsList(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 410,
      color: Colors.white,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(height: 7.5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedclubsList.insert(0, clubslist[index]);
                    selectedclubCodesList.insert(0, clubCodesList[index]);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7.5)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 2,
                            color: Colors.grey,
                            offset: Offset(1, 1))
                      ],
                    ),
                    child: Center(
                      child: Text(clubslist[index],
                          style: GoogleFonts.exo2(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: clubslist.length,
      ),
    );
  }

  selectedClubsList(context) {
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
                    selectedclubsList.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color(colorChoices[index]),
                  ),
                  width: 120,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Text(
                        selectedclubsList[index],
                        style: GoogleFonts.exo2(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10)
            ],
          );
        },
        itemCount: selectedclubsList.length,
      ),
    );
  }

  confirmClubsButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          var clubHelper = ClubDatabase.instance;
          List<Club> databaseClubs = await clubHelper.getAllClubs();
          int initialClubLength = databaseClubs.length;
          for (int i = 0;
              i < selectedclubsList.length - initialClubLength;
              i++) {
            Club club = Club(
                id: 0,
                club: selectedclubsList[i],
                clubCode: selectedclubCodesList[i]);
            clubHelper.addClub(club);
          }

          String finalClubCodeList = '';
          for (int i = 0; i < selectedclubsList.length; i++) {
            var response = await get(
              Uri.parse(
                  '${global.url}club/search?query=${selectedclubsList[i]}'),
            );

            var uploadClubs = ClubsList.fromJson(
              json.decode(response.body),
            );
            finalClubCodeList += uploadClubs.clubs[0].clubCode;
          }
          var userHelper = UserDatabase.instance;
          var databaseUser = await userHelper.getAllUsers();
          var sid = databaseUser[0].sid;

          Map<String, String> headers = {"Content-type": "application/json"};
          String jsonupload =
              '{"SID": $sid, "Club_codes": "$finalClubCodeList"}';

          Response response = await http.put(
              Uri.parse('${global.url}club/$sid'),
              headers: headers,
              body: jsonupload);
          setState(() {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => EntryPoint()));
          });
        },
        child: Text('Confirm Clubs',
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
