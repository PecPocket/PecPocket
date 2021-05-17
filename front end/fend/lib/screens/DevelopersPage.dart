import 'package:fend/app.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DevelopersPage extends StatefulWidget {
  @override
  _DevelopersPageState createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage> {
  var devListAvatars = [
    'assets/55.png',
    'assets/53.png',
    'assets/49.png',
    'assets/56.png'
  ];
  var devListNames = ['Dhruv Kauts', 'Guneet Kaur', 'Isha Garg', 'Kalash Jain'];
  var devListSids = ['19103085', '19103098', '19103109', '19103098'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 100),
          Text(
            'PecPocket Dev Team',
            style: GoogleFonts.exo2(
                color: Colors.teal, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 500,
            child: GridView.builder(
              itemCount: devListSids.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                      ),
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                devListAvatars[index]),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        devListNames[index],
                                        style: GoogleFonts.exo2(
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ), //The names go here
                                      Text(
                                        devListSids[index],
                                        style: GoogleFonts.exo2(
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ), //The SIDS go here
                                    ],
                                  ),
                                ),
                                height: 160,
                                margin: EdgeInsets.all(6),
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 7,
                                        offset: Offset(-1.0, 1.0))
                                  ],
                                  color: Color(colorChoices[index + 4]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
