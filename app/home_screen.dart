//home screenv3

import 'dart:convert';
import 'package:endproject/notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'job_details.dart';

// Fetch profile details
Future<Map<String, dynamic>> fetchProfileNameAndBillCode(int userId) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2/allapi/fetch_user.php?user_id=$userId'));
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

// Fetch only the most recent job entry with working_status <= 1
Future<Map<String, dynamic>> fetchMostRecentJobDetails(int userId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2/allapi/fetch_status.php?user_id=$userId'),
  );

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Filter out jobs with working_status of 1 or 3
        final filteredData = data
            .where((job) =>
                job['working_status'] == 1 || job['working_status'] == 3)
            .toList();

        if (filteredData.isNotEmpty) {
          // Handle different date formats if necessary
          filteredData.sort((a, b) {
            DateTime dateA = _parseDate(a['date']);
            DateTime dateB = _parseDate(b['date']);
            return dateB.compareTo(dateA); // Sort in descending order
          });
          return filteredData.first as Map<String, dynamic>;
        } else {
          return {}; // Return an empty map if no jobs match the criteria
        }
      } else {
        return {}; // Return an empty map if no jobs are found
      }
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  } else {
    throw Exception('Failed to load job details');
  }
}

Future<bool> checkAllStatus(int userId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2/allapi/fetch_all_status.php?user_id=$userId'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final allStatusCheck = data['all_status_check'] ?? 0;

    return allStatusCheck == 1; // ถ้าค่าเป็น 1 แสดงว่าสถานะถูกเช็คครบแล้ว
  } else {
    throw Exception('Failed to load status');
  }
}

Future<List<dynamic>> fetchImages() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2/allapi/get_images.php'));
  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } catch (e) {
      throw Exception('Failed to parse images JSON: $e');
    }
  } else {
    throw Exception('Failed to load images');
  }
}

DateTime _parseDate(String? dateString) {
  try {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now(); // Default date if null or empty
    }
    // Adjust the format according to your actual date format
    return DateTime.parse(dateString);
  } catch (e) {
    print('Error parsing date: $e');
    return DateTime.now(); // Default date if parsing fails
  }
}

class HomeScreen extends StatefulWidget {
  final int userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>>? _profileFuture;
  Future<Map<String, dynamic>>? _jobDetailsFuture;
  Future<List<dynamic>>? _imagesFuture;
  int? allStatusChecked;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfileNameAndBillCode(widget.userId);
    _jobDetailsFuture = fetchMostRecentJobDetails(widget.userId);
    _imagesFuture = fetchImages();
    checkAllStatus(widget.userId).then((value) {
      setState(() {
        allStatusChecked = value ? 1 : 0;
      });
    });
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('d MMM');
      final formattedDate = formatter.format(date);

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

      final parts = formattedDate.split(' ');
      final day = parts[0];
      final month = monthMap[DateFormat('MMMM').format(date)] ?? 'เดือนไม่ทราบ';

      return '$day $month';
    } catch (e) {
      return 'วันที่ไม่ทราบ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(5),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children: [
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _profileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14.0),
                        );
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สวัสดี  ${data['profile_name'] ?? 'User'}',
                              style: const TextStyle(
                                  fontSize: 30.0, color: Colors.white),
                            ),
                            Text(
                              'รหัสวางบิล : ${data['bill_code'] ?? ''}',
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ],
                        );
                      } else {
                        return const Text(
                          'User Profile',
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        );
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications,
                      color: Colors.white, size: 35),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationScreen(userId: widget.userId),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('picture/BG2-01.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'งานใหม่ล่าสุด',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            _profileFuture =
                                fetchProfileNameAndBillCode(widget.userId);
                            _jobDetailsFuture =
                                fetchMostRecentJobDetails(widget.userId);
                            _imagesFuture = fetchImages();
                            checkAllStatus(widget.userId).then((value) {
                              setState(() {
                                allStatusChecked = value ? 1 : 0;
                              });
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _jobDetailsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        if (data.isEmpty) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Center(
                              child: Text(
                                'ไม่มีงานวันนี้',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        } else {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['job_key'] ?? 'ไม่ทราบ',
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formatDate(data['date'] ??
                                          DateTime.now().toIso8601String()),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data['location_to_name'] ?? 'บริษัทไม่ทราบ',
                                  style: const TextStyle(fontSize: 22.0),
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
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 60.0,
                                  child: ElevatedButton(
                                    onPressed: allStatusChecked == 1
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    JobDetailsScreen(
                                                        userId: widget.userId),
                                              ),
                                            );
                                          }
                                        : null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        allStatusChecked == 1
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'ข้อมูลงานทั้งหมด',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Text(
                              'ไม่พบข้อมูล',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'ข่าวสาร',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  FutureBuilder<List<dynamic>>(
                    future: _imagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final images = snapshot.data!;
                        return Column(
                          children: images.take(3).map((image) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Image.network(
                                'http://10.0.2.2/allapi/${image['file_path']}',
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // Set width to screen width
                                fit: BoxFit.contain, // Adjust fit as needed
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No images found');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
