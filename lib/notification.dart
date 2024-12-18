import 'package:flutter/material.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gasguard_final/footer.dart';
import 'header.dart';
import 'models/Notification.dart'; // Import Header widget

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      // Get the username from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');

      if (username != null) {
        // Fetch notifications for the user
        FirestoreService firestoreService = FirestoreService();
        List<NotificationModel> fetchedNotifications =
        await firestoreService.getNotifications(username);

        // Update the state with fetched notifications
        setState(() {
          _notifications = fetchedNotifications;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Notifications'),
      backgroundColor: const Color.fromARGB(255, 200, 232, 213), // Light green
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications available.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: _groupNotificationsByDate(_notifications)
              .map((group) => NotificationGroupWidget(group: group))
              .toList(),
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: 3),
    );
  }

  List<NotificationGroup> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    Map<String, List<NotificationModel>> grouped = {};

    for (var notification in notifications) {
      if (!grouped.containsKey(notification.date)) {
        grouped[notification.date] = [];
      }
      grouped[notification.date]!.add(notification);
    }

    return grouped.entries
        .map((entry) => NotificationGroup(
      date: entry.key,
      notifications: entry.value
          .map((notif) => NotificationItem(
        title: notif.title,
        description: notif.body,
      ))
          .toList(),
    ))
        .toList();
  }
}

class NotificationGroupWidget extends StatefulWidget {
  final NotificationGroup group;

  const NotificationGroupWidget({super.key, required this.group});

  @override
  State<NotificationGroupWidget> createState() =>
      _NotificationGroupWidgetState();
}

class _NotificationGroupWidgetState extends State<NotificationGroupWidget> {
  bool _isExpanded = true; // Dropdown starts expanded by default

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color:
      const Color.fromARGB(255, 144, 221, 175), // Dropdown background color
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.group.date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: const Color(0xFF004B23),
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded; // Toggle expansion
                });
              },
            ),
          ),
          if (_isExpanded)
            Column(
              children: widget.group.notifications
                  .map((notification) => NotificationCard(
                title: notification.title,
                description: notification.description,
              ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF004B23),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notification_important,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationGroup {
  final String date;
  final List<NotificationItem> notifications;

  NotificationGroup({required this.date, required this.notifications});
}

class NotificationItem {
  final String title;
  final String description;

  NotificationItem({required this.title, required this.description});
}
