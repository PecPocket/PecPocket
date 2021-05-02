class Uploads {
  final List<String> uploads;

  Uploads({this.uploads});

  factory Uploads.fromJson(Map<String, dynamic> parsedJson) {
    var uploadsFromJson = parsedJson['Uploads'];
    List<String> uploadsList = uploadsFromJson.cast<String>();

    return new Uploads(
      uploads: uploadsList,
    );
  }
}