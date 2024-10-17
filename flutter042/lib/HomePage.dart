import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700], 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700], // 
                foregroundColor: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาว
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15), // ปรับขนาดปุ่ม
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // ปรับขอบมนของปุ่ม
                ),
              ),
              child: Text('Login Page'),
            ),
            SizedBox(height: 10),

            // คลิกตัวอักษร Register แทนการใช้ปุ่ม
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Register New Account', 
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red, // ตั้งค่าสีตัวอักษร
                  decoration: TextDecoration.underline, // เพิ่มเส้นใต้เพื่อให้ดูเหมือนลิงก์
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.pink[30], // ตั้งค่าพื้นหลังของหน้าเป็นสีชมพูอ่อน
    );
  }
}
