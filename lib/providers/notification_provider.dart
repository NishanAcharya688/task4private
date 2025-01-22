import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final String _storageKey = 'notifications';
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  NotificationProvider() {
    _loadNotifications();
  }

  // Load notifications from Shared Preferences
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList(_storageKey) ?? [];
    _notifications = storedData
        .map((item) => NotificationModel.fromJson(json.decode(item)))
        .toList();
    _updateUnreadCount();
  }

  // Save notifications to Shared Preferences
  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData =
        _notifications.map((n) => json.encode(n.toJson())).toList();
    await prefs.setStringList(_storageKey, storedData);
  }

  // Add a new notification
  Future<void> addNotification(NotificationModel notification) async {
    _notifications.insert(0, notification); // Add to the top
    await _saveNotifications();
    _updateUnreadCount();
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    await _saveNotifications();
    _updateUnreadCount();
  }

  // Update unread count
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }
}
