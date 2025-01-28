import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import 'widgets/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: Column(
        children: [
          // Notifications list
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
          // Two simple buttons at the bottom
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Mark All as Read button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<NotificationProvider>().markAllAsRead();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CupertinoColors.systemGrey4),
                    child: const Text('Mark All as Read'),
                  ),
                ),
                const SizedBox(width: 8), // Space between buttons
                // Delete All button with confirmation dialog
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final shouldDelete =
                          await _showDeleteConfirmationDialog(context);
                      if (shouldDelete) {
                        context
                            .read<NotificationProvider>()
                            .deleteAllNotifications();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CupertinoColors.systemGrey4),
                    child: const Text('Delete All'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Confirmation dialog for Delete All button
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content:
            const Text('Are you sure you want to delete all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((value) => value ?? false); // Default to false if dismissed
  }
}
