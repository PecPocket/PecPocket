import 'package:flutter/material.dart';

class StudentModel {
  final int sid;
  final String name;
  final String email;

  StudentModel.fromJson(Map<String, dynamic> parsedJson)
      : sid = parsedJson['SID'],
        name = parsedJson['name'],
        email = parsedJson['email'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "SID": sid,
      "email": email,
      "name": name,
    };
  }
}
