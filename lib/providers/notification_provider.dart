import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'dart:convert';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int _newCount = 0;
  int _nextId = 0;

  NotificationProvider() {
    _loadNotifications(); // Load notifications from SharedPreferences
  }

  List<NotificationModel> get notifications => _notifications;
  int get newCount => _newCount;

  void addNotification(NotificationModel notification) async {
    // Assign the next available ID
    final notificationWithId = NotificationModel(
      id: _nextId++, // Auto-increment the ID
      title: notification.title,
      body: notification.body,
      isRead: notification.isRead,
      timestamp: notification.timestamp,
      redirectPage: notification.redirectPage,
    );

    _notifications.insert(0, notificationWithId);
    _newCount++;

    // Save updated list to SharedPreferences
    await _saveNotifications();
    notifyListeners();
  }

  void noNewNotifications() async {
    _newCount = 0;
    // Save updated list to SharedPreferences
    await _saveNotifications();
    notifyListeners();
  }

  void markAsRead(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      //=================================================================================NEW COUNT=========
      // _newCount =
      // _notifications.where((n) => !n.isRead).length; // Update newCount
      await _saveNotifications();
      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }

  void markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true; // Mark each notification as read
    }
    _newCount = 0; // All notifications are read, so new count is 0,
    await _saveNotifications(); // Save updated notifications
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void deleteAllNotifications() async {
    _notifications.clear(); // Clear the notifications list
    _newCount = 0; // Reset new count
    await _saveNotifications(); // Save the updated list
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationJson =
        _notifications.map((notification) => notification.toJson()).toList();
    await prefs.setString('notifications', json.encode(notificationJson));
    await prefs.setInt('newCount', _newCount);
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationString = prefs.getString('notifications');
    final savedNewCount = prefs.getInt('newCount') ?? 0;

    if (notificationString != null) {
      final decodedNotifications = json.decode(notificationString) as List;
      _notifications = decodedNotifications
          .map((notification) =>
              NotificationModel.fromJson(notification as Map<String, dynamic>))
          .toList();
    }

    _newCount = savedNewCount;
    notifyListeners();
  }
}
