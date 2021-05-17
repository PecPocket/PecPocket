class StudentData {
  String email;
  String name;
  int sid;
  int code;
  int auth;
  String subcode;
  String subject;

  StudentData.fromJson(Map<String, dynamic> parsedJson) {
    email = parsedJson['Email'];
    name = parsedJson['Name'];
    sid = parsedJson['SID'];
  }
}

class Subjects {
  String subject;
  String subCode;

  Subjects.fromJson(Map<String, dynamic> parsedJson) {
    subject = parsedJson['Subject'];
    subCode = parsedJson['Subject_code'];
  }
}

class Clubs {
  String club;
  String clubCode;

  Clubs.fromJson(Map<String, dynamic> parsedJson) {
    club = parsedJson['Club'];
    clubCode = parsedJson['Club_code'];
  }
}

class Social {
  String name;
  int sid;
  String branch;
  int year;
  int semester;
  String insta;
  List<dynamic> clubs;
  String avatar;
  Social({
    this.name,
    this.sid,
    this.branch,
    this.year,
    this.semester,
    this.insta,
    this.clubs,
    this.avatar,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    var clubsList = json['Clubs'];
    return new Social(
      name: json['Name'],
      sid: json['SID'],
      branch: json['Branch'],
      year: json['Year'],
      semester: json['Semester'],
      insta: json['Insta'],
      clubs: clubsList,
      avatar: json['Avatar'],
    );
  }
}

class SocialList {
  // ignore: deprecated_member_use
  List<Social> social;

  SocialList({this.social});

  factory SocialList.fromJson(List<dynamic> parsedJson) {
    List<Social> social = new List<Social>();
    social = parsedJson.map((i) => Social.fromJson(i)).toList();
    return new SocialList(
      social: social,
    );
  }
}
