import 'package:fend/classes/user.dart';

class UserSignUp {
  int sid;
  int auth;

  UserSignUp({this.sid, this.auth});

  UserSignUp.fromJson(Map<String, dynamic> parsedJson) {
    sid = parsedJson['sid'];
    auth = parsedJson['auth'];
  }
}