import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter042/HomePage.dart';
import 'package:flutter042/pages/admin/modules/admininfo.dart';
import 'package:flutter042/pages/admin/modules/getbooking_page.dart';
import 'package:flutter042/pages/admin/modules/room_status_page.dart';
import 'package:flutter042/pages/admin/modules/userData/index.dart';
import 'package:flutter042/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0; // เก็บค่า index ของแท็บที่เลือก

  // ฟังก์ชันที่ใช้แสดงหน้าต่างถามเมื่อล็อกเอาท์
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).onLogout();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String token = Provider.of<UserProvider>(context, listen: false).accessToken; // ดึง accessToken จาก UserProvider

    // วิดเจ็ตของแต่ละแท็บ
    final List<Widget> _tabs = [
      const UserInfoTab(), // หน้าโปรไฟล์แอดมิน
      RoomStatusPage(token: token), // ส่ง token ไปยัง RoomStatusPage
      GetBookingPage(token: token), // ส่ง token ไปยัง ApprovalBookingPage
      const UserTab(), // หน้า User Data
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _showLogoutDialog(context); // เรียกใช้ฟังก์ชันยืนยันการล็อกเอาท์
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // เปลี่ยนพื้นหลังให้เป็นสีชมพูอ่อน
      body: IndexedStack(
        index: _selectedIndex, // แสดงวิดเจ็ตตาม selectedIndex
        children: _tabs,
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.indigo[700],
        activeColor: Colors.white,
        color: Colors.white,
        items: const [
          TabItem(icon: Icons.admin_panel_settings, title: 'Profile'), // ไอคอนโปรไฟล์แอดมิน
          TabItem(icon: Icons.meeting_room, title: 'Status'), // ไอคอนสำหรับตรวจสอบสถานะห้องประชุม
          TabItem(icon: Icons.check_circle, title: 'Approve'), // ไอคอนการอนุมัติการจองห้องประชุม
          TabItem(icon: Icons.person, title: 'User Data'), // ไอคอนการจัดการข้อมูลผู้ใช้
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int i) {
          setState(() {
            _selectedIndex = i; // อัปเดต index เมื่อมีการเลือกแท็บ
          });
        },
      ),
    );
  }
}
