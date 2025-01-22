class NotificationModel {
  final String title;
  final String body;
  final String redirectPage;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.redirectPage,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      redirectPage: json['redirectPage'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'redirectPage': redirectPage,
      'isRead': isRead,
    };
  }
}
