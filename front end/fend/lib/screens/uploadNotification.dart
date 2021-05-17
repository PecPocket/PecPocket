import 'package:fend/Databases/UserDB.dart';
import 'package:fend/EntryPoint.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class UploadNotification extends StatefulWidget {
  @override
  _UploadNotificationState createState() => _UploadNotificationState();
}

class _UploadNotificationState extends State<UploadNotification> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TimeOfDay selectedTime;
  DateTime selectedDate;
  String date;
  String time;
  String topic;
  String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: AppBar(
        backgroundColor: Color(0xff272727),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            color: Color(0xff272727),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Set Notification",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  controller: titleController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'TITLE',
                    labelStyle: TextStyle(
                      color: Color(0x95ffffff),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  validator: (val) {
                    return val.isEmpty ? 'Enter the title of the task' : null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'DESCRIPTION',
                    labelStyle: TextStyle(
                      color: Color(0x95ffffff),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  validator: (val) {
                    return val.isEmpty
                        ? 'Enter the description of the task'
                        : null;
                  },
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 330,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate(selectedDate),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        selectedDate = await _selectDate(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.calendar_today_rounded),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTime(selectedTime),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        selectedTime = await _selectTime(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.timer),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: uploadNotification,
                  child: Text('Create Notification'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff272727),
                    minimumSize: Size(MediaQuery.of(context).size.width, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff272727),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return pickedDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    TimeOfDay initial = TimeOfDay.now();
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        helpText: "Time of Notification",
        initialTime: initial,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xff272727),
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    return pickedTime;
  }

  String formattedDate(DateTime selectedDate) {
    if (selectedDate == null) {
      return 'Select Date';
    }
    return DateFormat("EEEE, d MMMM").format(selectedDate);
  }

  String formattedTime(TimeOfDay selectedTime) {
    if (selectedTime == null) {
      return 'Select Time';
    }
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(selectedTime);
  }

  uploadNotification() async {
    date = DateFormat("dd-MM-yyyy").format(selectedDate);
    time = selectedTime.toString().substring(10, 15);
    topic = titleController.text;
    description = descriptionController.text;

    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"Topic" : "$topic", "Description": "$description", "Date": "$date", "Time": "$time"}';

    var userHelper = UserDatabase.instance;
    var databaseUsers = await userHelper.getAllUsers();
    print(databaseUsers[0].sid);

    //var response = await post(Uri.parse('${global.url}/noti/${databaseUsers[0].sid}'),
    var response = await post(
        Uri.parse('${global.url}noti/${databaseUsers[0].sid}'),
        headers: headers,
        body: json);
    setState(
      () {
        print(response.body);
      },
    );
    if (response.body.length == 18) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Notification Uploaded')));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EntryPoint()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Check date and time format')));
    }
  }
}
