import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // นำเข้าแพคเกจ http
import 'dart:convert'; // สำหรับ jsonEncode
import 'package:flutter042/varbles.dart';
import 'package:flutter042/HomePage.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roomNumController = TextEditingController();
  String? selectedFaculty; // ตัวแปรสำหรับเก็บ faculty ที่เลือก
  String? selectedRole; // ตัวแปรสำหรับเก็บ role ที่เลือก

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String id = idController.text;
      String password = passwordController.text;
      String firstname = firstnameController.text;
      String lastname = lastnameController.text;
      String phone = phoneController.text;
      String roomNum = roomNumController.text;
      String faculty = selectedFaculty ?? ''; // ใช้ค่า faculty ที่เลือก
      String role = selectedRole ?? ''; // ใช้ค่า role ที่เลือก

      // ตรวจสอบ username ในฐานข้อมูล
      final response = await http.post(
        Uri.parse(
            '$apiURL/api/auth/check_username'), // URL สำหรับตรวจสอบ username
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': id}), // ใช้ id เป็น username
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['exists']) {
          // แจ้งเตือนว่า id นี้มีอยู่แล้ว
          _showMessage(context, 'This id already exists.');
        } else {
          // บันทึกข้อมูลลงในฐานข้อมูล
          final registerResponse = await http.post(
            Uri.parse('$apiURL/api/auth/register'), // URL สำหรับบันทึกข้อมูล
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'id': id, // เพิ่ม id
              'password': password,
              'firstname': firstname,
              'lastname': lastname,
              'faculty': faculty,
              'phone': phone,
              'roomNum': roomNum,
              'role': role,
            }),
          );

          if (registerResponse.statusCode == 201) {
            // แจ้งเตือนว่าลงทะเบียนสำเร็จ
            _showMessage(context, 'Registration successful.');

            // นำทางกลับไปยังหน้า home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false, // ลบเส้นทางก่อนหน้า
            ); // กลับไปยังหน้า HomePage
          } else {
            // แจ้งเตือนข้อผิดพลาดในการลงทะเบียน
            _showMessage(context, 'Registration failed. Please try again.');
          }
        }
      } else {
        // แจ้งเตือนข้อผิดพลาดในการตรวจสอบ username
        _showMessage(context, 'Error checking username. Please try again.');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    // ฟังก์ชันสำหรับแสดงข้อความแจ้งเตือน
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true, // เปิดใช้งานสีพื้นหลัง
                  fillColor: Colors.white, // สีพื้นหลังเป็นสีขาว
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedFaculty,
                decoration: InputDecoration(
                  labelText: 'Faculty',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                isExpanded: true,
                items: [
                  'Faculty of Science and Digital Innovation',
                  'Faculty of Education',
                  'Faculty of Technology and Community Development',
                  'Faculty of Health and Sports Sciences',
                  'Faculty of Law',
                  'Faculty of Engineering',
                  'Faculty of Nursing',
                  'Faculty of Agricultural and Biological Industry'
                ].map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(
                      faculty,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedFaculty = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your faculty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: roomNumController,
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your room number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem(
                    value: 'user',
                    child: Text('User'),
                  ),
                ],
                onChanged: (value) {
                  selectedRole = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your role';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _register(context),
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
