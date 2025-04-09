import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProfileNameAndBillCode(int userId) async {
  final response = await http.get(
      Uri.parse('http://10.0.2.2/allapi/fetch_user.php?user_id=$userId'));
  if (response.statusCode == 200) {
    try {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        return data;
      } else {
        throw Exception('Failed to load profile details');
      }
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load profile details');
  }
}

class MoreScreen extends StatefulWidget {
  final int userId;

  MoreScreen({required this.userId});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<Map<String, dynamic>>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfileNameAndBillCode(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14.0)),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อ : ${data['profile_name'] ?? 'User'}',
                          style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'รหัสวางบิล : ${data['bill_code'] ?? ''}',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text('User Profile',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14.0)));
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'picture/BG2-01.png',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)));
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        _buildSectionTitle('ข้อมูลส่วนตัว'),
                        _buildProfileContainer([
                          _buildProfileCard(
                              'รหัสวางบิล', '${data['bill_code']}'),
                          _buildProfileCard('ชื่อ', '${data['profile_name']}'),
                          _buildProfileCard('โทรศัพท์', '${data['phone']}'),
                        ]),
                        const SizedBox(height: 16),
                        _buildSectionTitle('ข้อมูลยานพาหนะ'),
                        _buildProfileContainer([
                          _buildProfileCard(
                              'ประเภทรถ', '${data['car_type']}'),
                          _buildProfileCard(
                              'ทะเบียนรถ', '${data['car_regis']}'),
                          _buildProfileCard('จังหวัดออกทะเบียน',
                              '${data['regis_province']}'),
                          _buildProfileCard('ยี่ห้อ', '${data['car_brand']}'),
                          _buildProfileCard('หมายเลขตัวถัง',
                              '${data['tank_number']}'),
                        ]),
                        const SizedBox(height: 16),
                        _buildSectionTitle('สังกัด'),
                        _buildProfileContainer([
                          _buildProfileCard('เจ้าหน้าที่ดูแล',
                              '${data['department_leader']}'),
                          _buildProfileCard('เบอร์ติดต่อเจ้าหน้าที่ดูแล',
                              '${data['department_phone']}'),
                          _buildProfileCard('สาขา', '${data['branch']}'),
                        ]),
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ออกจากระบบ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: Text('No data available',
                        style: TextStyle(color: Colors.black)));
              }
            },
          ),
        ],
      ),
    );
  }

  // Methods for building profile sections
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildProfileContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildProfileCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
