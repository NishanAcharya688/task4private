import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:task4/main.dart';

class FirebaseApi {
  //create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  //function to initialize notifications
  Future<void> initNotifications() async{
    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for this service
    final fCMToken = await _firebaseMessaging.getToken();

    //print the token (normally you would send this to your server)
    print('Token: $fCMToken');

    //initialize further settings for push noti
    initPushNotifications();
    listenToForegroundNotifications();
  }
  
  //function to handle received messages
  void handleMessage(RemoteMessage? message, {required String notificationState}){
    // if message null, do nothing
    if(message == null) return;
    
    //navigate to new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: {
        'message' : message,
        'state' : notificationState, // Pass the state
      }
    );
  }

  //function to initialize foreground and background settings
  Future initPushNotifications() async{
    //handle notification if the app was terminated and now opened
    await FirebaseMessaging.instance.getInitialMessage().then(
      (message) => handleMessage(message, notificationState: 'terminated'),
    );

    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => handleMessage(message, notificationState: 'background'),
    );
  }
  void listenToForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            title: Text(message.notification!.title ?? 'No Title'),
            content: Text(message.notification!.body ?? 'No Body'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  handleMessage(message, notificationState: 'foreground');
                },
                child: Text('View'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
                child: Text('Dismiss'),
              ),
            ],
          ),
        );
      }
    });
  }
}