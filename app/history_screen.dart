import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'history_deatail.dart';

// Fetch job details from the server with working_status = 2
Future<List<Map<String, dynamic>>> fetchHistoryDetails(int userId) async {
  final response = await http.get(
      Uri.parse('http://10.0.2.2/allapi/fetch_status.php?user_id=$userId'));
  
  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      
      // Filter to show only those with working_status = 2 or 4
      final filteredData = data.where((item) =>
          item['working_status'] == 2 || item['working_status'] == 4).toList();

      // Sort by date in descending order
      filteredData.sort((a, b) =>
          DateTime.parse(b['date_start']).compareTo(DateTime.parse(a['date_start'])));

      return filteredData.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load job details');
  }
}


class HistoryScreen extends StatefulWidget {
  final int userId;

  const HistoryScreen({super.key, required this.userId});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<Map<String, dynamic>>>? _historyDetailsFuture;

  @override
  void initState() {
    super.initState();
    _historyDetailsFuture = fetchHistoryDetails(widget.userId);
  }

  // Method to refresh data
  void _refreshData() {
    setState(() {
      _historyDetailsFuture = fetchHistoryDetails(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ประวัติการทำงาน',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData, // Call refresh method
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _historyDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final historyDetails = snapshot.data!;
              final uniqueDetails = historyDetails.toSet().toList();
              return ListView.builder(
                itemCount: uniqueDetails.length,
                itemBuilder: (context, index) {
                  final data = uniqueDetails[index];
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['job_key'] ?? 'ไม่ทราบ',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['location_to_name'] ?? 'บริษัทไม่ทราบ',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'วันที่เริ่มงาน: ${data['date_start'] ?? 'ไม่ทราบ'}',
                          style: const TextStyle(
                              fontSize: 14.0, fontStyle: FontStyle.normal),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.blue),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'รับ: ${data['location_from_name'] ?? 'สถานที่รับไม่ทราบ'}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.red),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'ส่ง: ${data['location_to_name'] ?? 'สถานที่ส่งไม่ทราบ'}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to HistoryDetailScreen and pass the job key
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryDetailScreen(
                                  jobKey: data[
                                      'job_key'], // Pass the job_key to HistoryDetailScreen
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Rounded corners
                            ),
                            elevation: 5, // Shadow elevation
                          ),
                          child: const Text(
                            'ดูรายละเอียด',
                            style: TextStyle(
                              fontSize: 16.0, // Font size
                              fontWeight: FontWeight.bold, // Bold text
                            ),
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
