class NotificationList {
  final List<Notification> notification;

  NotificationList({
    this.notification,
  });

  factory NotificationList.fromJson(List<dynamic> parsedJson) {
    List<Notification> notification = new List<Notification>();
    notification = parsedJson.map((i) => Notification.fromJson(i)).toList();

    return new NotificationList(notification: notification);
  }
}

class Notification {
  final String topic;
  final String description;
  final String date;
  final String time;

  Notification({this.topic, this.description, this.date, this.time});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return new Notification(
      topic: json['Topic'],
      description: json['Description'],
      date: json['Date'].toString(),
      time: json['Time'].toString(),
    );
  }
}
