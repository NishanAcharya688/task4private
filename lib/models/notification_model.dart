import 'dart:convert';

class NotificationModel {
  final String title;
  final String body;
  final DateTime timestamp;
  final String redirectPage;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
    required this.redirectPage,
    this.isRead = false,
  });

  // Convert NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'redirectPage': redirectPage,
      'isRead': isRead,
    };
  }

  // Convert JSON back to NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      redirectPage: json['redirectPage'],
      isRead: json['isRead'] ?? false,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
