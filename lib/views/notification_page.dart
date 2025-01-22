import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import 'widgets/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            trailing: notification.isRead
                ? null
                : const Icon(Icons.circle, color: Colors.red, size: 10),
          );
        },
      ),
    );
  }
}
