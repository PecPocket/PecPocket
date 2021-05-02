import 'package:alert_dialog/alert_dialog.dart';
import 'package:fend/Databases/ClubsDB.dart';
import 'package:fend/screens/HamburgerMenu.dart';
import 'package:fend/screens/HamburgerMenuOptions/AddClubs.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';

class UpdateClubs extends StatefulWidget {
  String title;
  UpdateClubs({this.title});
  @override
  _UpdateClubsState createState() => _UpdateClubsState();
}

List<String> currentClubs = [];

class _UpdateClubsState extends State<UpdateClubs> {
  String subtitle = 'YOUR CLUBS';

  @override
  Widget build(BuildContext context) {
    if(currentClubs.length == 0) {
      setState(() {
        subtitle = 'CHOOSE YOUR CLUBS';
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
              itemCount: currentClubs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    var dbHelper = ClubDatabase.instance;
                    dbHelper.deleteClub(currentClubs[index]);
                    setState(() {
                      currentClubs.removeAt(index);
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
                              text: '  ' + currentClubs[index],
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
              }),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddClubs()));
                });
              },
              child: Text('Add Clubs'),
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
