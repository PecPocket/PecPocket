final String tableClubs = 'Club';

class ClubFields {
  static final List<String> values = [
    id,
    club,
  ];
  static final String id = '_id';
  static final String club = 'club';
}

class Club {
  final int id;
  final String club;

  const Club({
    this.id,
    this.club,
  });

  Club copy({
    int id,
    String club,
  }) =>
      Club(
        id: id ?? this.id,
        club: club ?? this.club,
      );

  static Club fromJson(Map<String, Object> json) => Club(
        id: json[ClubFields.id] as int,
        club: json[ClubFields.club] as String,
      );

  Map<String, Object> toJson() => {
        ClubFields.id: id,
        ClubFields.club: club,
      };
}
