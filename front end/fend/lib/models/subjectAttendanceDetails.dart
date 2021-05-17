class SubjectAttendanceDetails {
  String subjectName;
  String subtitle;
  String status;
  int selectedColor; //to be stored on sqlite
  int attended;
  int total;
  double percentage;

  SubjectAttendanceDetails(
      String subjectName, String subtitle, int selectedColor, int attended, int total) {
    this.subjectName = subjectName;
    this.subtitle = subtitle;
    this.selectedColor = selectedColor;
    this.attended = attended;
    this.total = total;
    if (attended == total) {
      percentage = 99.99;
    } else {
      percentage = (attended / total) * 100;
    }
  }
}
