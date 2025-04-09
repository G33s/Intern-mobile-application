import 'dart:convert';
import 'package:http/http.dart' as http;

// ฟังก์ชันสำหรับดึงข้อมูลจาก fetch_user.php
Future<String> fetchProfileName(int userId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2/allapi/fetch_user.php?user_id=$userId'));

  if (response.statusCode == 200) {
    try {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return data['profile_name'] ?? 'ไม่ทราบชื่อ';
      } else {
        throw Exception('Failed to load profile name');
      }
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load profile name');
  }
}

// ฟังก์ชันสำหรับดึงข้อมูลจาก fetch_status.php
Future<Map<String, dynamic>> fetchJobDetails(int userId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2/allapi/fetch_status.php?user_id=$userId'));

  if (response.statusCode == 200) {
    try {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return {
          'job_key': data['job_key'] ?? 'N/A',
          'date': DateTime.now().toIso8601String(), // ใช้วันที่ปัจจุบัน
          'company': data['location_to_name'] ?? 'N/A',
          'location_from_name': data['location_from_name'] ?? 'N/A',
          'location_to_name': data['location_to_name'] ?? 'N/A',
        };
      } else {
        throw Exception('Failed to load job details');
      }
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load job details');
  }
}
