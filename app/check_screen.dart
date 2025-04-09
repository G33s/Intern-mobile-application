import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

class CheckScreen extends StatefulWidget {
  final int userId; // Add userId as an int

  CheckScreen({required this.userId}); // Constructor

  @override
  _CheckScreenState createState() => _CheckScreenState();
}

Future<List<Map<String, dynamic>>> fetchJobDetails(int userId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2/allapi/fetch_status.php?user_id=$userId'),
  );

  if (response.statusCode == 200) {
    // Parse the JSON response
    List<Map<String, dynamic>> jobDetails = List<Map<String, dynamic>>.from(json.decode(response.body));
    return jobDetails;
  } else {
    // Handle error
    throw Exception('Failed to load job details');
  }
}

class _CheckScreenState extends State<CheckScreen> {
  final Map<String, Map<String, bool>> _checkboxStates = {
    'check1': {'ready': false, 'notReady': false},
    'check2': {'ready': false, 'notReady': false},
    'check3': {'ready': false, 'notReady': false},
    'check4': {'ready': false, 'notReady': false},
    'check5': {'ready': false, 'notReady': false},
    'check6': {'ready': false, 'notReady': false},
    'check7': {'ready': false, 'notReady': false},
    'check8': {'ready': false, 'notReady': false},
    'check9': {'ready': false, 'notReady': false},
    'check10': {'ready': false, 'notReady': false},
    'check11': {'ready': false, 'notReady': false},
    'check12': {'ready': false, 'notReady': false},
    'check13': {'ready': false, 'notReady': false},
    'check15': {'ready': false, 'notReady': false},
    'check16': {'ready': false, 'notReady': false},
  };

  String status14Text = '';
  final TextEditingController _status14Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตรวจสภาพรถ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCheckContainer(context, 'picture/check1.png', 'check1'),
          _buildCheckContainer(context, 'picture/check2.png', 'check2'),
          _buildCheckContainer(context, 'picture/check3.png', 'check3'),
          _buildCheckContainer(context, 'picture/check4.png', 'check4'),
          _buildCheckContainer(context, 'picture/check5.png', 'check5'),
          _buildCheckContainer(context, 'picture/check6.png', 'check6'),
          _buildCheckContainer(context, 'picture/check7.png', 'check7'),
          _buildCheckContainer(context, 'picture/check8.png', 'check8'),
          _buildCheckContainer(context, 'picture/check9.png', 'check9'),
          _buildCheckContainer(context, 'picture/check10.png', 'check10'),
          _buildCheckContainer(context, 'picture/check11.png', 'check11'),
          _buildCheckContainer(context, 'picture/check12.png', 'check12'),
          _buildCheckContainer(context, 'picture/check13.png', 'check13'),
          _buildTextBoxContainer(context, 'picture/check14.png', 'check14'),
          _buildCheckContainer(context, 'picture/check15.png', 'check15'),
          _buildCheckContainer(context, 'picture/check16.png', 'check16'),
          const SizedBox(height: 20.0),
          _buildButtonSection(context),
        ],
      ),
    );
  }

  Widget _buildCheckContainer(
      BuildContext context, String imagePath, String key) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showFullSizeImage(context, imagePath),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12.0),
          _buildCheckbox('พร้อม', key, true),
        ],
      ),
    );
  }

  Widget _buildTextBoxContainer(
      BuildContext context, String imagePath, String key) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showFullSizeImage(context, imagePath),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _status14Controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter text',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onChanged: (value) {
              setState(() {
                status14Text = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, String key, bool isForReady) {
    return Row(
      children: [
        Checkbox(
          value:
              _checkboxStates[key]?[isForReady ? 'ready' : 'notReady'] ?? false,
          onChanged: (bool? value) {
            setState(() {
              if (isForReady) {
                _checkboxStates[key] = {
                  'ready': value ?? false,
                  'notReady': false
                };
              } else {
                _checkboxStates[key] = {
                  'ready': false,
                  'notReady': value ?? false
                };
              }
            });
          },
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildButtonSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(context, 'ยืนยัน', Colors.red, () {
          // Check if all checkboxes are checked
          bool allChecked = _checkboxStates.values
              .every((checkbox) => checkbox['ready'] == true);

          // Check if the text box is filled
          bool isTextBoxFilled = status14Text.isNotEmpty;

          // Show warning if not all conditions are met
          if (!allChecked || !isTextBoxFilled) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'ข้อผิดพลาด',
              desc: isTextBoxFilled
                  ? 'กรุณากรอกข้อมูลให้ครบถ้วนก่อนทำการบันทึก'
                  : 'กรุณากรอกข้อมูลในช่องที่กำหนด',
              btnOkOnPress: () {},
            ).show();
            return; // Exit early if validation fails
          }

          // If all checks pass, proceed with sending data to the server
          _sendDataToServer();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'ยืนยัน',
            desc: 'บันทึกการตรวจของคุณเรียบร้อยแล้ว',
            btnOkOnPress: () {},
          ).show();
        }),
      ],
    );
  }

  Widget _buildButton(
      BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFullSizeImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InteractiveViewer(
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        );
      },
    );
  }

  Future<void> _sendDataToServer() async {
  // Prepare the status values
  Map<String, dynamic> statusValues = {
    'user_id': widget.userId.toString(),
    'status_1': '1',
    'status_2': '1',
    'status_3': '1',
    'status_4': '1',
    'status_5': '1',
    'status_6': '1',
    'status_7': '1',
    'status_8': '1',
    'status_9': '1',
    'status_10': '1',
    'status_11': '1',
    'status_12': '1',
    'status_13': '1',
    'status_14': status14Text,  // Assuming this is the inputted text
    'status_15': '1',
    'status_16': '1',
  };

  // Add logic for all_status_check (set it to 1 if all fields are filled)
  statusValues['all_status_check'] =
      statusValues.values.every((val) => val == '1') ? '1' : '0';

  try {
    // Send the request to the server with form-urlencoded encoding
    final response = await http.post(
      Uri.parse('http://10.0.2.2/allapi/check_status.php'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: statusValues.map((key, value) => MapEntry(key, value.toString())), // Convert all values to string
    );

    if (response.statusCode == 200) {
      print('Data sent successfully. Response: ${response.body}');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending data: $e');
  }
}




}
