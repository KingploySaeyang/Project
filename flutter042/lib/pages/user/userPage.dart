import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter042/providers/user_provider.dart'; // นำเข้า provider สำหรับจัดการการ logout
import 'package:flutter042/HomePage.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserProvider>(context).user; // ใช้ user แทน userModel

    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
        backgroundColor: Colors.pink[400],
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // ไอคอนล็อกเอาท์
            onPressed: () {
              _showLogoutDialog(context); // เรียกใช้ฟังก์ชันยืนยันการล็อกเอาท์
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${userModel.firstname} ${userModel.lastname}!', // แสดงชื่อผู้ใช้
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ฟังก์ชันจองห้อง
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Book Room', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างและกลับไปหน้าเดิม
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                // ลบข้อมูลการล็อกอินทั้งหมด
                Provider.of<UserProvider>(context, listen: false).onLogout();
                Navigator.of(context).pop(); // ปิดหน้าต่าง
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false, // กลับไปยังหน้า HomePage
                );
              },
            ),
          ],
        );
      },
    );
  }
}
