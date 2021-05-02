import 'package:dio/dio.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart';

class UploadNotification extends StatefulWidget {
  @override
  UploadNotificationState createState() => UploadNotificationState();
}

class UploadNotificationState extends State<UploadNotification> {
  String topic;
  String description;
  String date;
  String time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Send Notification",
          style: TextStyle(
            color: Color(0xffCADBE4),
            fontSize: 32,
          ),
        ),
        backgroundColor: Color(0xff588297),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Topic',
                ),
                onChanged: (String value) {
                  setState(() {
                    topic = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (String value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                onChanged: (String value) {
                  setState(() {
                    date = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Time',
                ),
                onChanged: (String value) {
                  setState(() {
                    time = value;
                  });
                },
              ),
              Container(height: 20,),
              uploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  uploadButton() {
    return ElevatedButton(
        onPressed: uploadNotification,
        child: Text('Upload'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Color(0xffE28F22); // Use the component's default.
          },
        ),
      ),
    );
  }

  uploadNotification() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"Topic" : "$topic", "Description": "$description", "Date": "$date", "Time": "$time"}';

    var userHelper = UserDatabase.instance;
    var databaseUsers = await userHelper.getAllUsers();
    print(databaseUsers[0].sid);

    //var response = await post(Uri.parse('${global.url}/noti/${databaseUsers[0].sid}'),
    var response = await post(Uri.parse('${global.url}/noti/19103098'),
        headers: headers, body: json);
    setState(() {
      print(response.body);
    });
  }
}
