import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter/material.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  List<String> notifications = [
    'New video from channel A',
    'New comment on your video',
    'Channel B started live streaming',
    'Your video got 1000 views',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fake Notifications'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Dismissible(
                
                key: UniqueKey(),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  setState(() {
                    notifications.removeAt(index);
                  });
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        'https://picsum.photos/seed/${Random().nextInt(1000)}/50/50'),
                  ),
                  title: Text(notification),
                  subtitle: Text('Channel ${index + 1}'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

