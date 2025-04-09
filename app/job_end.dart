//j end
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:endproject/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JobEndScreen(userId: 1, jobKey: 'ไม่ทราบ'),
    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class JobEndScreen extends StatefulWidget {
  final int userId;
  final String jobKey;

  const JobEndScreen({Key? key, required this.userId, required this.jobKey})
      : super(key: key);

  @override
  _JobStartScreenState createState() => _JobStartScreenState();
}

class _JobStartScreenState extends State<JobEndScreen> {
  List<Map<String, dynamic>> jobData = [];
  bool isLoading = true;
  String? jobDate;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchJobData();
  }

  Future<void> uploadImageAndCompleteJob(
      File imageFile, int userId, String jobKey) async {
    // 1. Upload image
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://10.0.2.2/allapi/app_upload.php'), // Replace with your server URL
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );
    request.fields['user_id'] = userId.toString();
    request.fields['job_key'] = jobKey;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
      // Now call the method to update the job status and navigate to HomePage
      await updateWorkingStatus();
      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userId: userId,
            jobKey: jobKey,
          ),
        ),
      );
    } else {
      print('Failed to upload image.');
      // Handle error
    }
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
      final response = await http.post(
        Uri.parse('http://10.0.2.2/allapi/update_job_status.php'),
        body: json.encode({
          'user_id': widget.userId,
          'job_key': widget.jobKey,
          'working_status': 2,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          // Successfully updated working status
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobEndScreen(
                userId: widget.userId,
                jobKey: widget.jobKey,
              ),
            ),
          );
        } else {
          // Handle failure case
          print('Failed to update working status: ${result['message']}');
        }
      } else {
        // Print the entire response body for debugging
        print('Server error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Provide more details about the error
      print('Error updating working status: $error');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
                          color: Colors.grey,
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
                          color: Colors.blue),
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
                          child: Image.asset('picture/car2.png'),
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

                                    // Upload Image Button
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Logic to pick an image from gallery
                                        final pickedFile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          setState(() {
                                            _imageFile = File(pickedFile.path);
                                          });
                                        } else {
                                          // Error: No image selected
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            headerAnimationLoop: false,
                                            animType: AnimType.topSlide,
                                            title: 'ไม่สำเร็จ',
                                            desc: 'คุณไม่ได้เลือกรูปภาพ',
                                            btnOkText: 'ตกลง',
                                            btnOkOnPress: () {},
                                          ).show();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'อัพโหลดรูป',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 20), // Space between buttons

                                    // Complete Job Button
                                    SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_imageFile == null) {
                                              // Show an alert to the user to pick an image
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                headerAnimationLoop: false,
                                                animType: AnimType.topSlide,
                                                title: 'Error',
                                                desc:
                                                    'Please select an image before completing the job.',
                                                btnOkText: 'ตกลง',
                                                btnOkOnPress: () {},
                                              ).show();
                                            } else {
                                              // Proceed to upload image and complete the job
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.question,
                                                headerAnimationLoop: false,
                                                animType: AnimType.topSlide,
                                                title: 'ยืนยันจบงาน',
                                                desc:
                                                    'คุณต้องการจบงานนี้ใช่หรือไม่หลังจากกด ตกลง ท่านจะถูกส่งไปหน้าหลัก',
                                                btnOkText: 'ตกลง',
                                                btnCancelText: 'ยกเลิก',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () async {
                                                  await uploadImageAndCompleteJob(
                                                      _imageFile!,
                                                      widget.userId,
                                                      widget.jobKey);
                                                },
                                              ).show();
                                            }
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
                                            'จบงาน',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  ],
                                )
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
