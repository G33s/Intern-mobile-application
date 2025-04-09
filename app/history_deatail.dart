import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryDetailScreen extends StatefulWidget {
  final String jobKey;

  const HistoryDetailScreen({Key? key, required this.jobKey}) : super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  Future<Map<String, dynamic>>? _jobDetailsFuture;

  @override
  void initState() {
    super.initState();
    _jobDetailsFuture = fetchJobDetails(widget.jobKey);
  }

  // Function to fetch job details from API
  Future<Map<String, dynamic>> fetchJobDetails(String jobKey) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/allapi/fetch_job_detail.php?job_key=$jobKey'),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load job details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดงาน',
          style: TextStyle(color: Colors.white), // กำหนดสีข้อความเป็นขาว
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white, // กำหนดสีข้อความทั้งหมดใน AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jobDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final jobDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  buildCombinedDetailCard(jobDetails),
                  buildDetailsCard(jobDetails),
                  buildStatusDetailCard(jobDetails),
                ],
              ),
            );
          } else {
            return const Center(child: Text('ไม่พบข้อมูล'));
          }
        },
      ),
    );
  }

  Widget buildDetailsCard(Map<String, dynamic> jobDetails) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สถานที่ส่ง',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            buildSingleLineDetail('สถานที่ส่ง', jobDetails['location_to_name']),
            buildSingleLineDetail('จังหวัดส่ง', jobDetails['to_province_name']),
            buildSingleLineDetail('อำเภอส่ง', jobDetails['to_district_name']),
            buildSingleLineDetail(
                'ตำบลส่ง', jobDetails['to_sub_district_name']),
            buildSingleLineDetail('รหัสไปรษณีย์', jobDetails['to_post_code']),
            buildSingleLineDetail(
                'ที่อยู่เลขที่', jobDetails['to_building_number']),
            buildSingleLineDetail('เบอร์ติดต่อ', jobDetails['contact_number']),
          ],
        ),
      ),
    );
  }

  Widget buildCombinedDetailCard(Map<String, dynamic> jobDetails) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รายละสถานที่รับ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            buildSingleLineDetail('รหัสงาน', jobDetails['job_key']),
            buildSingleLineDetail(
                'สถานที่รับ', jobDetails['location_from_name']),
            buildSingleLineDetail(
                'จังหวัดรับ', jobDetails['from_province_name']),
            buildSingleLineDetail('อำเภอรับ', jobDetails['from_district_name']),
            buildSingleLineDetail(
                'ตำบลรับ', jobDetails['from_sub_district_name']),
            buildSingleLineDetail('รหัสไปรษณีย์', jobDetails['from_post_code']),
            buildSingleLineDetail(
                'ที่อยู่เลขที่', jobDetails['from_building_number']),
          ],
        ),
      ),
    );
  }

  Widget buildStatusDetailCard(Map<String, dynamic> jobDetails) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สถานะงาน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            buildSingleLineDetail(
              'สถานะงาน',
              _getStatusText(jobDetails['working_status']),
            ),
            buildSingleLineDetail('วันที่เริ่มงาน', jobDetails['date_start']),
            buildSingleLineDetail('เวลาเริ่มงาน', jobDetails['date_app_start']),
            buildSingleLineDetail('เวลาจบงาน', jobDetails['date_app_end']),
          ],
        ),
      ),
    );
  }

  // Function to get status text based on working_status
  String _getStatusText(int workingStatus) {
    switch (workingStatus) {
      case 2:
        return 'เสร็จงาน'; // Completed
      case 4:
        return 'ถูกยกเลิก'; // Canceled
      default:
        return workingStatus.toString(); // Other status as default
    }
  }

  Widget buildSingleLineDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value != null && value.isNotEmpty ? value : 'ไม่ทราบ',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
