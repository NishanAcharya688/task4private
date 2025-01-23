import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../main.dart';

enum AppState {
  foreground,
  background,
  terminated,
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final notification = NotificationModel(
      id: 0,
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      timestamp: DateTime.now(), // Timestamp set to current time
      // redirectPage: message.data['redirect'] ??
      // '/notification_page', // redirectPage not sent through console test messages
      redirectPage:
          '/${message.notification?.title?.split(':')[0].trim() ?? 'notification_page'}', // redirectPage 'page1' if title starts with 'Page1'
      isRead: false,
    );

    // Add notification to provider
    navigatorKey.currentState?.context
        .read<NotificationProvider>()
        .addNotification(notification);

    // Determine the app's state
    final appState = _getAppState();

    // Handle navigation based on the app's state
    switch (appState) {
      case AppState.terminated:
        // Delay navigation until the app is fully initialized
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState?.pushNamed(notification.redirectPage);
          } else {
            // Retry after a short delay if the navigator state is not ready
            Future.delayed(Duration(milliseconds: 100), () {
              navigatorKey.currentState?.pushNamed(notification.redirectPage);
            });
          }
        });
        break;
      case AppState.background:
        // Navigate immediately (app is already running)
        navigatorKey.currentState?.pushNamed(notification.redirectPage);
        break;
      case AppState.foreground:
        // No navigation required (app is in the foreground)
        break;
    }
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
      }
    });
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  AppState _getAppState() {
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      return AppState.foreground;
    } else if (WidgetsBinding.instance.lifecycleState ==
        AppLifecycleState.paused) {
      return AppState.background;
    } else {
      return AppState.terminated;
    }
  }
}
