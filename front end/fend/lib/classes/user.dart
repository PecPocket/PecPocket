final String tableUser = 'User';

class UserFields {
  static final List<String> values = [
    id,
    sid,
    password,
    auth,
    login,
  ];
  static final String id = '_id';
  static final String sid = 'sid';
  static final String password = 'password';
  static final String auth = 'auth';
  static final String login = 'login';
}

class User {
  final int id;
  final int sid;
  final String password;
  final int auth;
  final int login;

  const User({
    this.id,
    this.sid,
    this.password,
    this.auth,
    this.login,
  });

  User copy({
    int id,
    int sid,
    String password,
    int auth,
    int login,
  }) =>
      User(
        id: id ?? this.id,
        sid: sid ?? this.sid,
        password: password ?? this.password,
        auth: auth ?? this.auth,
        login: login ?? this.login,
      );

  static User fromJson(Map<String, Object> json) => User(
    id: json[UserFields.id] as int,
    sid: json[UserFields.sid] as int,
    password: json[UserFields.password] as String,
    auth: json[UserFields.auth] as int,
    login: json[UserFields.login] as int,
  );

  Map<String, Object> toJson() => {
    UserFields.id: id,
    UserFields.sid: sid,
    UserFields.password: password,
    UserFields.auth: auth,
    UserFields.login: login,
  };
}