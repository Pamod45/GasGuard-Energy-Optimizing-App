class NotificationModel {
  final String username;
  final String title;
  final String body;
  final String date;

  NotificationModel({
    required this.username,
    required this.title,
    required this.body,
    required this.date,
  });

  // Convert NotificationModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'title': title,
      'body': body,
      'date': date,
    };
  }

  // Create NotificationModel from a Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      username: map['username'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
