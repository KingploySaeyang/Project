import 'package:flutter/material.dart';
import 'package:flutter042/models/user_model.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel userModel;

  const UserDetailPage({required this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${userModel.user.firstname} ${userModel.user.lastname}',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.indigo[700], // เปลี่ยนสีพื้นหลัง AppBar
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.white, // เปลี่ยนสีของ Card เป็นสีขาว
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(150.0), // ความกว้างของคอลัมน์แรก
                1: FixedColumnWidth(200.0), // ความกว้างของคอลัมน์ที่สอง
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      'User ID:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.userId),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'First Name:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.firstname),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Last Name:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.lastname),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Faculty:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.faculty),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Phone:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.phone),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Room Number:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.roomNum),
                  ],
                ),
                // เพิ่มข้อมูลเพิ่มเติมที่ต้องการที่นี่
              ],
            ),
          ),
        ),
      ),
    );
  }
}
