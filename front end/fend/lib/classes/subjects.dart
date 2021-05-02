final String tableSubjects = 'subjects';

class SubjectFields {
  static final List<String> values = [id, subject];
  static final String id = '_id';
  static final String subject = 'subjects';
}

class Subject {
  final int id;
  final String subject;

  const Subject({this.id, this.subject});

  Subject copy({
    int id,
    String subject,
  }) =>
      Subject(
        id: id ?? this.id,
        subject: subject ?? this.subject,
      );

  static Subject fromJson(Map<String, Object> json) => Subject(
        id: json[SubjectFields.id] as int,
        subject: json[SubjectFields.subject] as String,
      );

  Map<String, Object> toJson() => {
        SubjectFields.id: id,
        SubjectFields.subject: subject,
      };
}
