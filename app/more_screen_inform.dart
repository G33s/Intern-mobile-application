// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoreScreenInform extends StatefulWidget {
  final int userId;

  MoreScreenInform({required this.userId, required profileName, required billCode});

  @override
  _MoreScreenInformState createState() => _MoreScreenInformState();
}

class _MoreScreenInformState extends State<MoreScreenInform> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfileNameAndBillCode(widget.userId);
  }

  Future<Map<String, dynamic>> fetchProfileNameAndBillCode(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2/allapi/fetch_user.php?user_id=$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        return data;
      } else {
        throw Exception('Failed to load profile details: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load profile details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent, // Gradient background can be achieved using Container in AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('ข้อมูลส่วนตัว'),
                  _buildProfileContainer([
                    _buildProfileCard('รหัสวางบิล', '${data['bill_code']}'),
                    _buildProfileCard('ชื่อ', '${data['profile_name']}'),
                    _buildProfileCard('โทรศัพท์', '${data['phone']}'),
                  ]),
                  const SizedBox(height: 16),
                  _buildSectionTitle('ข้อมูลยานพาหนะ'),
                  _buildProfileContainer([
                    _buildProfileCard('ประเภทรถ', '${data['car_type']}'),
                    _buildProfileCard('ทะเบียนรถ', '${data['car_regis']}'),
                    _buildProfileCard('จังหวัดออกทะเบียน', '${data['regis_province']}'),
                    _buildProfileCard('ยี่ห้อ', '${data['car_brand']}'),
                    _buildProfileCard('หมายเลขตัวถัง', '${data['tank_number']}'),
                  ]),
                  const SizedBox(height: 16),
                  _buildSectionTitle('สังกัด'),
                  _buildProfileContainer([
                    _buildProfileCard('เจ้าหน้าที่ดูแล', '${data['department_leader']}'),
                    _buildProfileCard('เบอร์ติดต่อเจ้าหน้าที่ดูแล', '${data['department_phone']}'),
                    _buildProfileCard('สาขา', '${data['branch']}'),
                  ]),
                ],
              );
            } else {
              return const Center(child: Text('No data available', style: TextStyle(color: Colors.black)));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildProfileContainer(List<Widget> cards) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cards,
      ),
    );
  }

  Widget _buildProfileCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
          Text(value, style: const TextStyle(fontSize: 16.0, color: Colors.black)),
        ],
      ),
    );
  }
}
