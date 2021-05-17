import 'dart:convert';
import 'dart:io';
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/classes/subjects.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/StudyMaterial/SubjectStudyMaterial.dart';
import 'package:fend/screens/StudyMaterial/SubjectStudyMaterial1.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart' as http;
import '../HamburgerMenu.dart';
import '../mainPage.dart';

class StudyMaterial0 extends StatefulWidget {
  StudyMaterial0State createState() => StudyMaterial0State();
}

List<String> subjectsList = [];
List<String> studyMaterialCodesList = [];
List<int> colorChoices = [
  0XffFECE48,
  0xff813CA3,
  0xff9A275A,
  0xffD97F30,
  0xff484F70,
  0xff2F3737,
  0xff23356C,
  0xffBDB8B0,
  0xff9F7F7F,
  0xff91C2C4,
  0xff84A59D,
  0xffE47A77,
  0xff6C96C6,
  0xff0B7A75
];

class StudyMaterial0State extends State<StudyMaterial0>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool isPlaying = false;
  var key = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    updateCodesList();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  File image;
  final picker = ImagePicker();
  @override
  Widget build(context) {
    return Scaffold(
      key: key,
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
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomAppBar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: AnimatedIcon(
            color: Colors.black,
            icon: AnimatedIcons.menu_close,
            progress: animationController,
          ),
          onPressed: () => handleOnPressed(),
        ),
      ),
      body: ListView(
        children: [
          Container(
            //height: 40,
            padding: EdgeInsets.fromLTRB(25, 10, 25, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Study Material',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: subjectsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 150,
              ),
              itemBuilder: (BuildContext context, int index) {
                int backgroundColor = colorChoices[(index + 1) % 14];
                return GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          child: Image.asset(
                            'assets/folder.png',
                            scale: 0.8,
                            color: Color(backgroundColor),
                          ),
                          opacity: 0.85,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              subjectsList[index],
                              //textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      var response = await get(Uri.parse(
                          '${global.url}subject/search?query=${subjectsList[index]}'));
                      var rb = response.body;

                      var list = json.decode(rb) as List;

                      List<Subjects> mySubjects =
                          list.map((i) => Subjects.fromJson(i)).toList();

                      var userHelper = UserDatabase.instance;
                      var userData = await userHelper.getAllUsers();
                      setState(
                        () {
                          uploadSubject0 = mySubjects[0].subCode;
                          uploadSubject = mySubjects[0].subCode;
                          if (uploadsList0.length != 0) {
                            uploadsList0.clear();
                          }
                          if (uploadsList.length != 0) {
                            uploadsList.clear();
                          }
                          if (userData[0].auth == 0 || userData[0].auth == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectStudyMaterial(
                                  index: index,
                                  subjectColor: backgroundColor,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectStudyMaterial1(
                                  index: index,
                                  subjectColor: backgroundColor,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    });
              },
            ),
          ),
        ],
      ),
      drawer: Settings(),
    );
  }

  fileChoice() {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: photoUploadGallery,
              child: Text('Upload photo from gallery')),
          ElevatedButton(
              onPressed: photoUploadGallery, child: Text('Upload pdf')),
        ],
      ),
    );
  }

  photoUploadGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        String filename = image.path.split('/').last;

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${global.url}/upload/$uploadSubject'),
        );

        request.files.add(http.MultipartFile.fromBytes(
            'file', File(image.path).readAsBytesSync(),
            filename: filename));

        sendRequest(request);
      }
    });
  }

  listSubjects() async {
    var dbHelper = SubjectDatabase.instance;
    List<Subject> databaseSubjects = await dbHelper.getAllSubjects();
    for (int i = 0; i < databaseSubjects.length; i++) {}
  }

  void sendRequest(http.MultipartRequest request) async {
    var res = await request.send();
    setState(() {
      print(res);
    });
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

  void updateCodesList() async {
    var subjectHelper = SubjectDatabase.instance;
    var databaseSubjects = await subjectHelper.getAllSubjects();
    for (int i = 0; i < databaseSubjects.length; i++) {
      var response = await get(Uri.parse(
          '${global.url}subject/search?query=${databaseSubjects[i].subject}'));
      var rb = response.body;

      var list = json.decode(rb) as List;

      List<Subjects> subjects = list.map((i) => Subjects.fromJson(i)).toList();

      setState(() {
        print(subjects[i].subCode);
      });
    }
  }
}
