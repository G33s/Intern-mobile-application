import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'job_mid.dart'; // Import the JobEndScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JobStartScreen(userId: 1, jobKey: 'ไม่ทราบ'),
    );
  }
}

class JobStartScreen extends StatefulWidget {
  final int userId;
  final String jobKey;

  const JobStartScreen({Key? key, required this.userId, required this.jobKey})
      : super(key: key);

  @override
  _JobStartScreenState createState() => _JobStartScreenState();
}

class _JobStartScreenState extends State<JobStartScreen> {
  List<Map<String, dynamic>> jobData = [];
  bool isLoading = true;
  String? jobDate;

  @override
  void initState() {
    super.initState();
    fetchJobData();
  }

  Future<void> fetchJobData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2/allapi/fetch_additional_job_details.php?job_key=${widget.jobKey}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> allJobs = json.decode(response.body);
        final List<Map<String, dynamic>> filteredJobs = allJobs
            .where((job) => job['job_key'] == widget.jobKey)
            .map((job) => job as Map<String, dynamic>)
            .toList();

        setState(() {
          jobData = filteredJobs;
          if (jobData.isNotEmpty) {
            jobDate = jobData[0]['date']; // Assign the date from the first job
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateWorkingStatus() async {
    try {
      // Get current time in the desired format (ISO 8601 format)
      String currentTime = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse('http://10.0.2.2/allapi/update_job_status.php'),
        body: json.encode({
          'user_id': widget.userId,
          'job_key': widget.jobKey,
          'working_status': 3,
          'date_app_start': currentTime, // Send current time
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          // Successfully updated working status and time
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobMidScreen(
                userId: widget.userId,
                jobKey: widget.jobKey,
              ),
            ),
          );
        } else {
          print('Failed to update working status: ${result['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error updating working status: $error');
    }
  }

  String formatDate(String isoDate) {
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
  }

  String getCurrentDate() {
    final now = DateTime.now();
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
    return '${now.day} ${thaiMonths[now.month - 1]} ${now.year + 543}';
  }

  Widget buildInfoContainer({
    required String title,
    required List<String> content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10.0,
          ),
        ],
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 12),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content
              .map((item) => Text(item, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'รหัสงาน: ${widget.jobKey}',
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'วันที่: ${jobDate != null ? formatDate(jobDate!) : getCurrentDate()}',
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add Container with Text between AppBar and Image
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'เริ่มงาน',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Container(
                      height: 20,
                      width: 2,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const Text(
                      'อยู่ระหว่างขนส่ง',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Container(
                      height: 20,
                      width: 2,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const Text(
                      'ส่งสินค้าปลายทาง',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset('picture/car1.png'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : jobData.isEmpty
                              ? const Center(child: Text('No data available'))
                              : Column(
                                  children: [
                                    buildInfoContainer(
                                      title: "รับจาก",
                                      content: [
                                        jobData[0]['location_from_name'] ??
                                            'Not specified',
                                        'จังหวัด: ${jobData[0]['from_province_name'] ?? 'Not specified'}',
                                        'เขต: ${jobData[0]['from_district_name'] ?? 'Not specified'}',
                                        'แขวง/ตำบล: ${jobData[0]['from_sub_district_name'] ?? 'Not specified'}',
                                        'รหัสไปรษณีย์: ${jobData[0]['from_post_code'] ?? 'Not specified'}',
                                        'ที่อยู่เลขที่: ${jobData[0]['from_building_number'] ?? 'Not specified'}',
                                      ],
                                      icon: Icons.location_on,
                                      iconColor: Colors.blueAccent,
                                    ),
                                    buildInfoContainer(
                                      title: "ส่งไปที่",
                                      content: [
                                        jobData[0]['location_to_name'] ??
                                            'Not specified',
                                        'จังหวัด: ${jobData[0]['to_province_name'] ?? 'Not specified'}',
                                        'เขต: ${jobData[0]['to_district_name'] ?? 'Not specified'}',
                                        'แขวง/ตำบล: ${jobData[0]['to_sub_district_name'] ?? 'Not specified'}',
                                        'รหัสไปรษณีย์: ${jobData[0]['to_post_code'] ?? 'Not specified'}',
                                        'ที่อยู่เลขที่: ${jobData[0]['to_building_number'] ?? 'Not specified'}',
                                        'เบอร์ติดต่อ: ${jobData[0]['contact_number'] ?? 'Not specified'}',
                                      ],
                                      icon: Icons.location_on,
                                      iconColor: Colors.redAccent,
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.info,
                                            headerAnimationLoop: false,
                                            animType: AnimType.topSlide,
                                            title: 'ยืนยันรับงาน',
                                            desc:
                                                'คุณต้องการยืนยันรับงานนี้ใช่หรือไม่',
                                            btnOkText: 'ตกลง',
                                            btnCancelText: 'ยกเลิก',
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () async {
                                              await updateWorkingStatus();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      JobMidScreen(
                                                    userId: widget.userId,
                                                    jobKey: widget.jobKey,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).show();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(16.0),
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'ยืนยันรับงาน',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
