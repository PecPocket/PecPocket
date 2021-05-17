class ClubsList {
  final List<ClubsUpload> clubs;

  ClubsList({this.clubs});

  factory ClubsList.fromJson(List<dynamic> parsedJson) {
    List<ClubsUpload> codes = new List<ClubsUpload>();
    var clubs = parsedJson.map((i) => ClubsUpload.fromJson(i)).toList();

    return new ClubsList(clubs: clubs);
  }
}

class ClubsUpload {
  final String clubName;
  final String clubCode;

  ClubsUpload({this.clubName, this.clubCode});

  factory ClubsUpload.fromJson(Map<String, dynamic> json) {
    return new ClubsUpload(
      clubName: json['Club'],
      clubCode: json['Club_code'],
    );
  }
}
