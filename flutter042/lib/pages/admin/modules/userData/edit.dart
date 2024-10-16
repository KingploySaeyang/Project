import 'package:flutter/material.dart';
import 'package:flutter042/controllers/admin_controller.dart'; // อัปเดตการนำเข้าคอนโทรลเลอร์ผู้ใช้ที่ถูกต้อง
import 'package:flutter042/models/user_model.dart'; // อัปเดตการนำเข้ารูปแบบผู้ใช้ที่ถูกต้อง
import 'package:flutter042/pages/admin/adminPage.dart';
import 'package:flutter042/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;

  const EditUserPage({required this.user, super.key});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _facultyController;
  late TextEditingController _phoneController;
  late TextEditingController _roomNumController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.user.lastname);
    _facultyController = TextEditingController(text: widget.user.user.faculty);
    _phoneController = TextEditingController(text: widget.user.user.phone);
    _roomNumController = TextEditingController(text: widget.user.user.roomNum);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _facultyController.dispose();
    _phoneController.dispose();
    _roomNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _facultyController,
              decoration: InputDecoration(
                labelText: 'Faculty',
                labelStyle: TextStyle(color: Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _roomNumController,
              decoration: InputDecoration(
                labelText: 'Room Number',
                labelStyle: TextStyle(color: Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _editUser(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.pink[50],
    );
  }

  void _editUser(BuildContext context) {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First name and last name cannot be empty.')),
      );
      return;
    }

    final updatedUser = {
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
      'faculty': _facultyController.text,
      'phone': _phoneController.text,
      'roomNum': _roomNumController.text, // เพิ่มการเปลี่ยนแปลงห้อง
    };

    final token = Provider.of<UserProvider>(context, listen: false).accessToken;

    setState(() {
      _isLoading = true; // เริ่มโหลด
    });

    // เรียกใช้ฟังก์ชัน updateUser ใน AdminController
    AdminController().updateUser(token, widget.user.user.id, updatedUser).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
        (route) => false, // ลบเส้นทางก่อนหน้า
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false; // สิ้นสุดการโหลด
      });
    });
  }
}
