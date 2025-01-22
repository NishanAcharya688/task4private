import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task4/providers/notification_provider.dart';
import 'package:task4/views/home_page.dart';
import 'package:task4/views/notification_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter FCM Demo',
        navigatorKey: navigatorKey, // Ensure this is already in your project
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/notification_page': (context) => const NotificationPage(),
        },
      ),
    );
  }
}
