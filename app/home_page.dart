import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import HomeScreen
import 'history_screen.dart'; // Import HistoryScreen
import 'check_screen.dart'; // Import CheckScreen
import 'more_screen.dart'; // Import MoreScreen
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final int userId; // Add userId parameter

  HomePage({required this.userId, required String jobKey}); // Add userId to constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // ignore: unused_field
  String _profileName = '';
  // ignore: unused_field
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = widget.userId; // Get userId from widget

    // ignore: unnecessary_null_comparison
    if (userId != null) {
      _fetchProfileName(userId);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProfileName(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/allapi/fetch_user.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          if (mounted) {
            setState(() {
              _profileName = data['profile_name'];
              _isLoading = false;
            });
          }
        } else {
          _showMessage('Failed to fetch profile name');
        }
      } else {
        _showMessage('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showMessage('Exception: $e');
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _onRefresh() async {
    // Refresh the data by fetching the profile name again
    await _fetchProfileName(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(userId: widget.userId),
      HistoryScreen(userId: widget.userId),
      CheckScreen(userId: widget.userId),
      MoreScreen(userId: widget.userId),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'ประวัติการงาน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'ตรวจสภาพ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ผู้ใช้งาน',
          ),
        ],
      ),
    );
  }
}
