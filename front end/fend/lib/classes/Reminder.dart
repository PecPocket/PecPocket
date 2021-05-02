final String tableReminders = 'reminders';

class ReminderFields {
  static final List<String> values = [
    id,
    description,
    year,
    month,
    day,
    hour,
    minute,
    getNotified
  ];
  static final String id = '_id';
  static final String description = 'description';
  static final String year = 'year';
  static final String month = 'month';
  static final String day = 'day';
  static final String hour = 'hour';
  static final String minute = 'minute';
  static final String getNotified = 'getNotified';
}

class Reminder {
  final int id;
  final String description;
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final bool getNotified;

  const Reminder(
      {this.id,
      this.description,
      this.year,
      this.month,
      this.day,
      this.hour,
      this.minute,
      this.getNotified});

  Reminder copy({
    int id,
    String description,
    int year,
    int month,
    int day,
    int hour,
    int minute,
    bool getNotified,
  }) =>
      Reminder(
        id: id ?? this.id,
        description: description ?? this.description,
        year: year ?? this.year,
        month: month ?? this.month,
        day: day ?? this.day,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        getNotified: getNotified ?? this.getNotified,
      );

  static Reminder fromJson(Map<String, Object> json) => Reminder(
        id: json[ReminderFields.id] as int,
        description: json[ReminderFields.description] as String,
        year: json[ReminderFields.year] as int,
        month: json[ReminderFields.month] as int,
        day: json[ReminderFields.day] as int,
        hour: json[ReminderFields.hour] as int,
        minute: json[ReminderFields.minute] as int,
        getNotified: json[ReminderFields.getNotified] == 1,
      );

  Map<String, Object> toJson() => {
        ReminderFields.id: id,
        ReminderFields.description: description,
        ReminderFields.year: year,
        ReminderFields.month: month,
        ReminderFields.day: day,
        ReminderFields.hour: hour,
        ReminderFields.minute: minute,
        ReminderFields.getNotified: getNotified ? 1 : 0,
      };
}
