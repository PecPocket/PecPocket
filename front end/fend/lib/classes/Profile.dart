class Profile {
  String name;
  int sid;
  String branch;
  int year;
  int semester;
  List<String> clubs;
  String insta;
  String avatar;

  Profile(
      {this.name,
      this.sid,
      this.branch,
      this.year,
      this.semester,
      this.clubs,
      this.insta,
      this.avatar});

  factory Profile.fromJson(Map<String, dynamic> parsedJson) {
    var clubsFromJson = parsedJson['Clubs'];

    List<String> clubsList = clubsFromJson.cast<String>();

    return new Profile(
      name: parsedJson['Name'],
      sid: parsedJson['SID'],
      branch: parsedJson['Branch'],
      year: parsedJson['Year'],
      semester: parsedJson['Semester'],
      avatar: parsedJson['Avatar'],
      clubs: clubsList,
    );
  }
}
