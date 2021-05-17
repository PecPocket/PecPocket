class CodesList {
  final List<Codes> codes;

  CodesList({this.codes});

  factory CodesList.fromJson(List<dynamic> parsedJson) {
    List<Codes> codes = new List<Codes>();
    codes = parsedJson.map((i) => Codes.fromJson(i)).toList();

    return new CodesList(codes: codes);
  }
}

class Codes {
  final String subjectName;
  final String subCode;

  Codes({this.subjectName, this.subCode});

  factory Codes.fromJson(Map<String, dynamic> json) {
    return new Codes(
      subjectName: json['Subject'],
      subCode: json['Sub_code'],
    );
  }
}
