import 'package:flutter/material.dart';
import 'package:flutter042/pages/admin/modules/edit_admin_profile.dart';
import 'package:flutter042/providers/user_provider.dart';
import 'package:provider/provider.dart'; 

class UserInfoTab extends StatelessWidget {
  const UserInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center( // ใช้ Center widget เพื่อจัดกลาง
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // จัดให้กลางแนวตั้ง
        children: [
          // กรอบข้อมูลผู้ใช้
          Container(
            width: 300, // กำหนดความกว้างของกล่อง
            padding: const EdgeInsets.all(16.0), // เพิ่ม Padding
            decoration: BoxDecoration(
              color: Colors.white, // กรอบสีขาว
              borderRadius: BorderRadius.circular(10), // มุมมน
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // เงา
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // เงาลง
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // จัดแนวซ้าย
              children: [
                const Text("User", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.user; // เข้าถึง user
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // จัดแนวซ้าย
                      children: [
                        Text(
                          'Name: ${user.firstname} ${user.lastname}', // แสดงชื่อผู้ใช้
                          style: const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        Text(
                          'Faculty: ${user.faculty}', // แสดงคณะ
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          'Phone: ${user.phone}', // แสดงหมายเลขโทรศัพท์
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          'Room Number: ${user.roomNum}', // แสดงหมายเลขห้อง
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Role: ${user.role}', // แสดง Role ของผู้ใช้
                          style: const TextStyle(color: Colors.black, fontSize: 18), // ปรับขนาดตัวอักษรให้เท่ากับข้อมูลอื่น
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // ฟังก์ชันสำหรับปุ่มแก้ไขข้อมูล
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditAdminProfilePage()), // เชื่อมโยงไปยังหน้า EditProfilePage
                            );
                          },
                          child: const Text("Edit Profile"), // ปุ่มแก้ไขข้อมูล
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30), // เว้นที่ระหว่างกรอบข้อมูลผู้ใช้กับ Access Token
          // แสดง Access Token
          Container(
            width: 300, // กำหนดความกว้างของกล่อง Access Token
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Access Token", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) => Text(
                    userProvider.accessToken,
                    style: const TextStyle(color: Color.fromARGB(255, 255, 26, 129), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // แสดง Refresh Token
          Container(
            width: 300, // กำหนดความกว้างของกล่อง Refresh Token
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Refresh Token", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) => Text(
                    userProvider.refreshToken,
                    style: const TextStyle(color: Color.fromARGB(255, 255, 26, 129), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
