import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'dart:convert';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  NotificationProvider() {
    _loadNotifications(); // Load notifications from SharedPreferences
  }

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  void addNotification(NotificationModel notification) async {
    _notifications.add(notification);

    if (!notification.isRead) {
      _unreadCount++;
    }

    // Save updated list to SharedPreferences
    await _saveNotifications();
    notifyListeners();
  }

  void markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    _unreadCount = 0;

    // Save updated list to SharedPreferences
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationJson =
        _notifications.map((notification) => notification.toJson()).toList();
    await prefs.setString('notifications', json.encode(notificationJson));
    await prefs.setInt('unreadCount', _unreadCount);
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationString = prefs.getString('notifications');
    final savedUnreadCount = prefs.getInt('unreadCount') ?? 0;

    if (notificationString != null) {
      final decodedNotifications = json.decode(notificationString) as List;
      _notifications = decodedNotifications
          .map((notification) =>
              NotificationModel.fromJson(notification as Map<String, dynamic>))
          .toList();
    }

    _unreadCount = savedUnreadCount;
    notifyListeners();
  }
}
