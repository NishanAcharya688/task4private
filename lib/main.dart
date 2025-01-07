import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task4/api/firebase_api.dart';
import 'package:task4/firebase_options.dart';
import 'package:task4/views/home_page.dart';
import 'package:task4/views/notification_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      navigatorKey: navigatorKey,
      routes: {
        '/notification_screen':(context)=> const NotificationPage(),
      },
    );
  }
}