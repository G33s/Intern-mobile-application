import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final int userId;

  NotificationScreen({required this.userId});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/allapi/fetch_notifications.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        setState(() {
          notifications = jsonResponse;

          if (notifications.isNotEmpty) {
            notifications.sort((a, b) {
              final dateA = DateTime.parse(a['date']);
              final dateB = DateTime.parse(b['date']);
              return dateB.compareTo(dateA);
            });

            notifications = [notifications.first];
          }
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  String formatDate(String dateString) {
    final monthMap = {
      'January': 'ม.ค.',
      'February': 'ก.พ.',
      'March': 'มี.ค.',
      'April': 'เม.ย.',
      'May': 'พ.ค.',
      'June': 'มิ.ย.',
      'July': 'ก.ค.',
      'August': 'ส.ค.',
      'September': 'ก.ย.',
      'October': 'ต.ค.',
      'November': 'พ.ย.',
      'December': 'ธ.ค.',
    };

    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('MMMM d yyyy');
      final formattedDate = formatter.format(date);

      final parts = formattedDate.split(' ');
      final day = parts[1];
      final month = monthMap[parts[0]] ?? 'เดือนไม่ทราบ';
      final year = parts[2];

      return '$day $month $year';
    } catch (e) {
      return 'วันที่ไม่ทราบ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 20), // Small space between AppBar and body
                Container(
                  constraints: BoxConstraints(
                    minWidth: 500,
                    maxWidth: 1000,
                    minHeight: 100,
                    maxHeight: 160,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Color.fromARGB(255, 54, 124, 228)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'งานใหม่เข้า',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'วันที่: ${notifications.first['date'] != null ? formatDate(notifications.first['date']) : 'ไม่ทราบ'}',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        '${notifications.first['message'] ?? 'ไม่ทราบ'}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 248, 248, 248),
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
