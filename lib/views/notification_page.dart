import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //get the notification message and display on screen
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final RemoteMessage message = args['message'];
    final String state = args['state'];

  String title;
  if(state == 'foreground'){
    title = 'Notified in Foreground';
  } else if(state == 'background'){
    title = 'Notified in background';
  } else {
    title = 'Notified while terminated';
  }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Text(message.notification!.title.toString()),
          Text(message.notification!.body.toString()),
          Text(message.data.toString()),
        ],
      ),
    );  }
}