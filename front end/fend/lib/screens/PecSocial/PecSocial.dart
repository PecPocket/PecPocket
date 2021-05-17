import 'dart:convert';
import 'dart:math';
import 'package:fend/classes/Profile.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/HamburgerMenu.dart';
import 'package:fend/screens/PecSocial/SocialViewProfile.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;

class PecSocial extends StatefulWidget {
  final Animation<double> transitionAnimation;
  const PecSocial({Key key, this.transitionAnimation}) : super(key: key);
  @override
  _PecSocialState createState() => _PecSocialState();
}

class _PecSocialState extends State<PecSocial>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool isPlaying = false;
  var key = GlobalKey<ScaffoldState>();
  List<String> avatars = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
    'assets/7.png',
    'assets/8.png',
    'assets/9.png',
    'assets/10.png',
    'assets/11.png',
    'assets/12.png',
    'assets/13.png',
    'assets/14.png',
    'assets/15.png',
    'assets/16.png',
    'assets/17.png',
    'assets/18.png',
    'assets/19.png',
    'assets/20.png',
    'assets/21.png',
    'assets/22.png',
    'assets/23.png',
    'assets/24.png',
    'assets/25.png',
    'assets/26.png',
    'assets/27.png',
    'assets/28.png',
    'assets/29.png',
    'assets/30.png',
    'assets/31.png',
    'assets/31.png',
    'assets/33.png',
    'assets/34.png',
    'assets/35.png',
    'assets/36.png',
    'assets/37.png',
    'assets/38.png',
    'assets/39.png',
    'assets/40.png',
    'assets/41.png',
    'assets/42.png',
    'assets/43.png',
    'assets/44.png',
    'assets/45.png',
    'assets/46.png',
    'assets/47.png',
    'assets/48.png',
    'assets/49.png',
    'assets/50.png',
    'assets/51.png',
    'assets/52.png',
    'assets/53.png',
    'assets/54.png',
    'assets/55.png',
    'assets/56.png',
    'assets/neutral_guy.png',
    'assets/neutral_girl.png'
  ];
  String searchFor;
  int searchForLength = 0;
  int initialSearchForLength = 0;
  List<String> names = [];
  List<String> sids = [];
  int i = 0;
  //default index of a first screen

  Animation<double> animation;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Color(0xffF0F2F5),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: key,
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 5),
                IconButton(
                  icon: AnimatedIcon(
                    color: Colors.black,
                    icon: AnimatedIcons.menu_close,
                    progress: animationController,
                  ),
                  onPressed: () => handleOnPressed(),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 25, bottom: 20),
              height: 105,
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter SID/Clubs/Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: Colors.grey, width: 0.75),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.5),
                    borderSide:
                        const BorderSide(color: Colors.teal, width: 0.75),
                  ),
                ),
                onChanged: (String value) {
                  searchFor = value;
                  searchForLength = value.length;
                  search();
                },
              ),
            ),
            searchFor == null || searchFor.length == 0
                ? Container(
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/Pecsocial.png'),
                    ),
                  )
                : Container(
                    child: Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 1.0,
                        ),
                        padding: EdgeInsets.only(bottom: 20),
                        itemCount: names.length ~/ 2,
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
                                      onTap: () async {
                                        print(sids[index]);
                                        var response = await get(Uri.parse(
                                            '${global.url}viewprofile/${sids[index]}'));
                                        Social profile = Social.fromJson(
                                            json.decode(response.body));
                                        socialName = profile.name;
                                        socialSid = profile.sid.toString();
                                        socialClubs = profile.clubs.length == 0
                                            ? ' Not in any clubs '
                                            : profile.clubs.toString();
                                        socialBranch =
                                            profile.branch.toString();
                                        socialYear = profile.year.toString();
                                        socialSemester =
                                            profile.semester.toString();
                                        socialInsta = profile.insta == null
                                            ? 'No instagram handle'
                                            : profile.insta;
                                        socialAvatar =
                                            'assets/${profile.avatar}';
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SocialViewProfile()));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/${avatars[index]}'),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  names[index],
                                                  style: GoogleFonts.exo2(
                                                    textStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ), //The names go here
                                                Text(
                                                  sids[index],
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 7,
                                                  offset: Offset(-1.0, 1.0))
                                            ],
                                            color: Color(getRandomListElement(
                                                colorChoices)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 7.5),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 7.5),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(),
      drawer: Settings(),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.home_filled,
          color: Colors.white,
          size: 35,
        ),
        onPressed: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void search() async {
    if (searchFor.length == 0) {
      setState(() {
        names.clear();
        sids.clear();
        avatars.clear();
        i = 0;
      });
    } else if (initialSearchForLength != searchForLength) {
      print(initialSearchForLength);
      print(searchForLength);

      names.clear();
      sids.clear();
      avatars.clear();
      var response =
          await get(Uri.parse('${global.url}social?query=$searchFor'));

      var socialList = SocialList.fromJson(json.decode(response.body));

      setState(() {
        print(socialList.social[0].name);
        for (int i = 0; i < socialList.social.length; i++) {
          names.add(socialList.social[i].name);
          sids.add(socialList.social[i].sid.toString());
          if (socialList.social[i].avatar == 'assets/neutral.png' ||
              socialList.social[i].avatar == null) {
            avatars.add('assets/41.png');
          } else
            avatars.add(socialList.social[i].avatar);
        }
      });
      initialSearchForLength = searchForLength;
    }
  }

  int getRandomListElement(List<int> colors) {
    var random = new Random();
    var i = random.nextInt(colors.length);
    return colors[i];
  }

  handleOnPressed() async {
    if (!isPlaying) {
      await animationController.forward();
      key.currentState?.openDrawer();
      animationController.reverse();
    }
    setState(() {
      print(isPlaying);
    });
  }
}
