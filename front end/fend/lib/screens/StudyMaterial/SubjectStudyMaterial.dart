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
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../HamburgerMenu.dart';

class SubjectStudyMaterial extends StatefulWidget {
  int index;
  SubjectStudyMaterial({this.index});

  @override
  _SubjectStudyMaterialState createState() => _SubjectStudyMaterialState();
}

List<String> uploadsList0 = [];
String uploadSubject0 = '';

class _SubjectStudyMaterialState extends State<SubjectStudyMaterial> {
  void downloadFile(String nameFile) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
          url:
              'https://8532a4f966b3.ngrok.io/download/$uploadSubject0/$nameFile',
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Material', style: TextStyle( color: Color(0xffCADBE4), fontSize: 28,),),
        backgroundColor: Color(0xff588297),
      ),
      drawer: Settings(),
      bottomNavigationBar: bottomAppBar(),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject: ${subjectsList[widget.index]}',
                    style: TextStyle(
                      color: Color(0xff235790),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                itemBuilder: (BuildContext context, int index){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/study_material_file.png',
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
