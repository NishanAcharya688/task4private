import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import 'widgets/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;
    context.watch<NotificationProvider>().noNewNotifications();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: notification.isRead
                        ? Colors.transparent
                        : Colors.grey[100],
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title:
                        Text('${notification.title} - ${notification.isRead}'),
                    subtitle: Text(notification.body),
                    onTap: () {
                      context
                          .read<NotificationProvider>()
                          .markAsRead(notification.id);

                      final routeName = notification.redirectPage;
                      Navigator.pushNamed(context, routeName);
                    },
                  ),
                );
              },
            ),
          ),
          // Mark All as Read button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<NotificationProvider>().markAllAsRead();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Mark All as Read',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
