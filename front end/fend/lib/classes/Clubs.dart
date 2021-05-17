final String tableClubs = 'Club';

class ClubFields {
  static final List<String> values = [
    id,
    club,
    clubCode,
  ];
  static final String id = '_id';
  static final String club = 'club';
  static final String clubCode = 'ClubCode';
}

class Club {
  final int id;
  final String club;
  final String clubCode;

  const Club({
    this.id,
    this.club,
    this.clubCode,
  });

  Club copy({
    int id,
    String club,
    String clubCode,
  }) =>
      Club(
        id: id ?? this.id,
        club: club ?? this.club,
        clubCode: clubCode ?? this.clubCode,
      );

  static Club fromJson(Map<String, Object> json) => Club(
        id: json[ClubFields.id] as int,
        club: json[ClubFields.club] as String,
        clubCode: json[ClubFields.clubCode] as String,
      );

  Map<String, Object> toJson() => {
        ClubFields.id: id,
        ClubFields.club: club,
        ClubFields.clubCode: clubCode,
      };
}
