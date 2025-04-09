import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'job_start.dart';
import 'job_mid.dart';

// Function to fetch job details
Future<List<Map<String, dynamic>>> fetchJobDetails(int userId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2/allapi/fetch_status.php?user_id=$userId'),
  );

  print('Response status: ${response.statusCode}');
  print(
      'Response body: ${response.body}'); // Print raw response body for debugging

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      // Filter to show only those with working_status = 1 or 3
      final filteredData = data
          .where((item) =>
              item['working_status'] == 1 || item['working_status'] == 3)
          .toList();

      // Sort by date_start in descending order
      filteredData.sort((a, b) => DateTime.parse(b['date_start'])
          .compareTo(DateTime.parse(a['date_start'])));

      // Convert filtered data to List<Map<String, dynamic>>
      return filteredData.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load job details');
  }
}

// JobDetailsScreen widget
class JobDetailsScreen extends StatefulWidget {
  final int userId;

  const JobDetailsScreen({super.key, required this.userId});

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  Future<List<Map<String, dynamic>>>? _jobDetailsFuture;

  @override
  void initState() {
    super.initState();
    _jobDetailsFuture = fetchJobDetails(widget.userId);
  }

  String formatDate(String isoDate) {
    try {
      final DateTime date = DateTime.parse(isoDate);
      final List<String> thaiMonths = [
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.'
      ];
      return '${date.day} ${thaiMonths[date.month - 1]} ${date.year + 543}';
    } catch (e) {
      return 'วันที่ไม่ทราบ';
    }
  }

  bool isToday(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateTime today = DateTime.now();
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    } catch (e) {
      return false;
    }
  }

  void _onReceiveJobPressed(int workingStatus, String jobKey) {
    if (workingStatus == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobStartScreen(
            userId: widget.userId,
            jobKey: jobKey,
          ),
        ),
      );
    } else if (workingStatus == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobMidScreen(
            userId: widget.userId,
            jobKey: jobKey,
          ),
        ),
      );
    }
  }

  // Function to refresh job details
  void _refreshJobDetails() {
    setState(() {
      _jobDetailsFuture = fetchJobDetails(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดงาน',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _refreshJobDetails, // Call refresh function
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _jobDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final details = snapshot.data!;
              return ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final data = details[index];
                  final bool isTodayJob = isToday(data['date_start'] ?? '');

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'รหัสงาน: ${data['job_key'] ?? 'ไม่ทราบ'}',
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'วันที่เริ่ม: ${data['date_start'] != null ? formatDate(data['date_start']) : 'ไม่ทราบ'}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_pin,
                                      color: Colors.blue),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'รับ: ${data['location_from_name'] ?? 'สถานที่รับไม่ทราบ'}',
                                      style: const TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_pin,
                                      color: Colors.red),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'ส่ง: ${data['location_to_name'] ?? 'สถานที่ส่งไม่ทราบ'}',
                                      style: const TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: (data['working_status'] == 1 &&
                                      isTodayJob) ||
                                  (data['working_status'] == 3)
                              ? () {
                                  _onReceiveJobPressed(data['working_status'],
                                      data['job_key'] ?? 'ไม่ทราบ');
                                }
                              : null, // Disable button if conditions aren't met
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: Text(
                            data['working_status'] == 3
                                ? 'อยู่ระหว่างขนส่ง'
                                : 'รับงาน',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (data['working_status'] == 1 &&
                                        isTodayJob) ||
                                    (data['working_status'] == 3)
                                ? (data['working_status'] == 3
                                    ? Colors.orange
                                    : Colors.blue)
                                : const Color.fromARGB(122, 0, 0,
                                    0), // Disable color if conditions aren't met
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('ไม่พบข้อมูล'));
            }
          },
        ),
      ),
    );
  }
}
