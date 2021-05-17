import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fend/models/Uploads.dart';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:fend/screens/attendance.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../HamburgerMenu.dart';
import '../mainPage.dart';

class SubjectStudyMaterial extends StatefulWidget {
  int index;
  int subjectColor;
  SubjectStudyMaterial({this.index, this.subjectColor});

  @override
  _SubjectStudyMaterialState createState() => _SubjectStudyMaterialState();
}

List<String> uploadsList0 = [];
String uploadSubject0 = '';
String fileIcon = 'assets/image.png';
bool isEmpty = false;

class _SubjectStudyMaterialState extends State<SubjectStudyMaterial> {
  void downloadFile(String nameFile) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
          url: '${global.url}download/$uploadSubject0/$nameFile',
          savedDir: baseStorage.path,
          fileName: '$nameFile',
          showNotification: true);
    } else {
      print('no permission');
    }
  }

  int progress = 0;
  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloadFile");

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
    showUploads();
  }

  static downloadCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloadFile");
    sendPort.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) {
      return Scaffold(
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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: bottomAppBar(),
        body: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Study Material/${subjectsList[widget.index]}',
                        style: GoogleFonts.exo2()),
                    Text(
                      '\nLong press the file icon to download the resource you need',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                child: GridView.builder(
                  itemCount: uploadsList0.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 150,
                    crossAxisSpacing: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (uploadsList0[index]
                            .substring(uploadsList0[index].length - 3) ==
                        'pdf') {
                      fileIcon = 'assets/pdf-file.png';
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Material(
                            child: Image.asset(
                              fileIcon,
                              color: Color(widget.subjectColor),
                              height: 70,
                            ),
                            //elevation: 10,
                          ),
                          onLongPress: () {
                            setState(() {
                              downloadFile(uploadsList0[index]);
                            });
                          },
                        ),
                        Container(
                          child: Text(
                            uploadsList0[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: bottomAppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 160, left: 10, right: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Study Material/${subjectsList[widget.index]}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/study_material.png',
              scale: 1.4,
            ),
            Container(
              height: 20,
            ),
            Text(
              'Looks like there is no study material available\nAsk your CR to Upload!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  showUploads() async {
    var response =
        await get(Uri.parse('${global.url}/getuploads/$uploadSubject0'));
    Uploads uploads = Uploads.fromJson(json.decode(response.body));
    setState(() {
      if (uploadsList0.length == 0) {
        for (int i = 0; i < uploads.uploads.length; i++) {
          uploadsList0.add(uploads.uploads[i].toString());
        }
      } else {
        uploadsList0.clear();
        for (int i = 0; i < uploads.uploads.length; i++) {
          uploadsList0.add(uploads.uploads[i].toString());
        }
      }
    });
  }
}
