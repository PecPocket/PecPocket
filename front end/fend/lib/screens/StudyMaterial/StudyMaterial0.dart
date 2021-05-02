import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:fend/Databases/SubjectsDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/classes/subjects.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/StudyMaterial/SubjectStudyMaterial.dart';
import 'package:fend/screens/StudyMaterial/SubjectStudyMaterial1.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../HamburgerMenu.dart';

class StudyMaterial0 extends StatefulWidget {
  StudyMaterial0State createState() => StudyMaterial0State();
}

List<String> subjectsList = [];

class StudyMaterial0State extends State<StudyMaterial0> {
  void initState() {
    super.initState();
    //updateSubjectsList();
  }

  File image;
  final picker = ImagePicker();
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Material', style: TextStyle( color: Color(0xffCADBE4), fontSize: 28,),),
        backgroundColor: Color(0xff588297),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {},
          ),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: bottomAppBar(),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: subjectsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 150,
          ),
          itemBuilder: (BuildContext context, int index){
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Image.asset(
                      'assets/study_material_folder.png',
                    scale: 0.8,
                  ),
                  onTap: () async {
                    var response = await get(Uri.parse(
                        '${global
                            .url}/subject/search?query=${subjectsList[index]}'));
                    var rb = response.body;

                    var list = json.decode(rb) as List;

                    List<Subjects> mySubjects =
                    list.map((i) => Subjects.fromJson(i)).toList();

                    var userHelper = UserDatabase.instance;
                    var userData = await userHelper.getAllUsers();
                    setState(() {
                      uploadSubject0 = mySubjects[0].subCode;
                      uploadSubject = mySubjects[0].subCode;
                      if (uploadsList0.length != 0) {
                        uploadsList0.clear();
                      }
                      if (uploadsList.length != 0) {
                        uploadsList.clear();
                      }
                      if (userData[0].auth == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubjectStudyMaterial(index: index,)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubjectStudyMaterial1(index: index,)));
                      }
                    },);
                  }
                ),
                Container(
                  child: Text(
                      subjectsList[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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

  void updateSubjectsList() async {
    var subjectsHelper = SubjectDatabase.instance;
    List<Subject> databaseSubjects = await subjectsHelper.getAllSubjects();
    for (int i = 0; i < databaseSubjects.length; i++) {
      subjectsList.add(databaseSubjects[i].subject);
    }
    //print(subjectsList.length);
  }

  void sendRequest(http.MultipartRequest request) async {
    var res = await request.send();
    setState(() {
      print(res);
    });
  }
}
