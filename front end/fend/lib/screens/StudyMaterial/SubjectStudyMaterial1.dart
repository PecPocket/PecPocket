import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:fend/screens/StudyMaterial/StudyMaterial0.dart';
import 'package:http/http.dart' as http;
import 'package:alert_dialog/alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:fend/models/Uploads.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../HamburgerMenu.dart';
import '../attendance.dart';
import '../mainPage.dart';

class SubjectStudyMaterial1 extends StatefulWidget {
  int index;
  int subjectColor;
  SubjectStudyMaterial1({this.index, this.subjectColor});

  @override
  _SubjectStudyMaterial1State createState() => _SubjectStudyMaterial1State();
}

List<String> uploadsList = [];
String uploadSubject = '';
String pageDescription =
    '\nLong press the file icon to download the resource you need';
String fileIcon = 'assets/image.png';
bool isEmpty = false;

class _SubjectStudyMaterial1State extends State<SubjectStudyMaterial1> {
  final picker = ImagePicker();
  void downloadFile(String nameFile) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
          url: '${global.url}download/$uploadSubject/$nameFile',
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
          actions: [
            IconButton(
                icon: Icon(
                  Icons.wifi,
                  color: Colors.black,
                ),
                onPressed: () {
                  //return alert(context, content: fileChoice());
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: fileChoice(),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    color: Color(0xff272727),
                                  ),
                                )),
                          ],
                        );
                      });
                }),
          ],
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
                    Text(
                      'Study Material/${subjectsList[widget.index]}',
                      style: TextStyle(
                        color: Colors.black,
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
                  itemCount: uploadsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 150,
                    crossAxisSpacing: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (uploadsList[index]
                            .substring(uploadsList[index].length - 3) ==
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
                              downloadFile(uploadsList[index]);
                            });
                          },
                        ),
                        Container(
                          child: Text(
                            uploadsList[index],
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
        await get(Uri.parse('${global.url}/getuploads/$uploadSubject'));
    Uploads uploads = Uploads.fromJson(json.decode(response.body));
    setState(() {
      if (uploads.uploads.isEmpty) {
        pageDescription =
            '\nNo study material available for this subject! Ask your CR to upload resources';
      }
      if (uploadsList.length == 0) {
        for (int i = 0; i < uploads.uploads.length; i++) {
          uploadsList.add(uploads.uploads[i].toString());
        }
      } else {
        uploadsList.clear();
        for (int i = 0; i < uploads.uploads.length; i++) {
          uploadsList.add(uploads.uploads[i].toString());
        }
      }
    });
  }

  fileChoice() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: photoUploadGallery,
            child: Text('Upload files'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff272727),
            ),
          ),
        ],
      ),
    );
  }

  photoUploadGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      File image;
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

  void sendRequest(http.MultipartRequest request) async {
    var res = await request.send();
    setState(() {
      print(res);
    });
  }
}
