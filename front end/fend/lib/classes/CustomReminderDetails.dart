class CustomReminderDetails {
  int reminderID;
  String title;
  String description;
  DateTime reminderDateTime;
  bool alarmRequired;

  CustomReminderDetails(this.reminderID, this.title, this.description,
      this.reminderDateTime, this.alarmRequired);
}
