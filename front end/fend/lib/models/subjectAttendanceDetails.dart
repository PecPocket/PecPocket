class SubjectAttendanceDetails {
  String subjectName;
  String subtitle;
  String status = "n/a";
  int attended;
  int total;
  double percentage;

  SubjectAttendanceDetails(
      String subjectName, String subtitle, int attended, int total) {
    this.subjectName = subjectName;
    this.subtitle = subtitle;
    this.attended = attended;
    this.total = total;
    if (attended == total) {
      percentage = 99.99;
    } else {
      percentage = (attended / total) * 100;
    }
  }
}
