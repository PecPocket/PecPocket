import 'dart:convert';
import '../models/student_model.dart';
import 'package:http/http.dart' show Client;

final _root = 'https://b7098c23c5a8.ngrok.io/super';

class StudentApiProvider {
  Client client = Client();
  // ignore: non_constant_identifier_names
  Future<List<int>> FetchStudentDataFromApi() async {
    final response = await client.get(Uri.parse('$_root/super'));
    final studentIndex = json.decode(response.body);
    return studentIndex.cast<int>();
  }

  // ignore: non_constant_identifier_names
  Future<StudentModel> FetchStudentItemFromApi(int sid) async {
    final response = await client.get(Uri.parse('$_root/super/$sid'));
    final parsedJson = json.decode(response.body);

    return StudentModel.fromJson(parsedJson);
  }
}
