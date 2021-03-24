import 'dart:async';
import 'student_api_provider.dart';
import 'student_db_provider.dart';
import '../models/student_model.dart';

class Repository {
  StudentApiProvider apiProvider = StudentApiProvider();
  StudentDbProvider dbProvider = StudentDbProvider();

  Future<List<int>> fetchStudentData() {
    return apiProvider.FetchStudentDataFromApi();
  }

  Future<StudentModel> fetchStudentItem(int sid) async {
    var newData = await dbProvider.fetchDataFromDataBase(sid);
    if (newData != null) {
      return newData;
    }

    newData = await apiProvider.FetchStudentItemFromApi(sid);
    dbProvider.addItemToDataBase(newData);

    return newData;
  }
}
