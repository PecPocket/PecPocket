final String tableAttendance = 'attendance';

class AttendancesFields {
  static final List<String> values = [
    id,
    subject,
    subtitle,
    classesAttended,
    totalClasses,
  ];
  static final String id = '_id';
  static final String subject = 'subject';
  static final String subtitle = 'subtitle';
  static final String classesAttended = 'classesAttended';
  static final String totalClasses = 'totalClasses';
}

class Attendances {
  final int id;
  final String subject;
  final String subtitle;
  final int classesAttended;
  final int totalClasses;

  const Attendances({
    this.id,
    this.subject,
    this.subtitle,
    this.classesAttended,
    this.totalClasses,
  });

  Attendances copy({
    int id,
    String subject,
    String subtitle,
    int classesAttended,
    int totalClasses,
  }) =>
      Attendances(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        subtitle: subtitle ?? this.subtitle,
        classesAttended: classesAttended ?? this.classesAttended,
        totalClasses: totalClasses ?? this.totalClasses,
      );

  static Attendances fromJson(Map<String, Object> json) => Attendances(
        id: json[AttendancesFields.id] as int,
        subject: json[AttendancesFields.subject] as String,
        subtitle: json[AttendancesFields.subtitle] as String,
        classesAttended: json[AttendancesFields.classesAttended] as int,
        totalClasses: json[AttendancesFields.totalClasses] as int,
      );

  Map<String, Object> toJson() => {
        AttendancesFields.id: id,
        AttendancesFields.subject: subject,
        AttendancesFields.subtitle: subtitle,
        AttendancesFields.classesAttended: classesAttended,
        AttendancesFields.totalClasses: totalClasses,
      };
}
