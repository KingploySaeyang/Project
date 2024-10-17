import 'package:flutter/material.dart';
import 'package:flutter042/controllers/admin_controller.dart';
import 'package:flutter042/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditAdminProfilePage extends StatefulWidget {
  const EditAdminProfilePage({super.key});

  @override
  _EditAdminProfilePageState createState() => _EditAdminProfilePageState();
}

class _EditAdminProfilePageState extends State<EditAdminProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _facultyController;
  late TextEditingController _phoneController;
  late TextEditingController _roomNumController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.user.firstname + ' ' + userProvider.user.lastname);
    _facultyController = TextEditingController(text: userProvider.user.faculty);
    _phoneController = TextEditingController(text: userProvider.user.phone);
    _roomNumController = TextEditingController(text: userProvider.user.roomNum);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _facultyController.dispose();
    _phoneController.dispose();
    _roomNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Admin Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700], // เปลี่ยนสีพื้นหลัง AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'User ID: ${userProvider.user.userId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${userProvider.user.role}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.indigo[700]), // เปลี่ยนสีข้อความ
                filled: true,
                fillColor: Colors.white, // สีพื้นหลังเป็นสีขาว
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _facultyController,
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomNumController,
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _editProfile(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700], // เปลี่ยนสีปุ่ม
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
      backgroundColor: Colors.white, // เปลี่ยนสีพื้นหลังเป็นสีชมพูอ่อน
    );
  }

  void _editProfile(BuildContext context) {
    if (_nameController.text.isEmpty || _facultyController.text.isEmpty || _phoneController.text.isEmpty || _roomNumController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fields cannot be empty.')),
      );
      return;
    }

    final updatedUser = {
      'firstname': _nameController.text.split(' ')[0],
      'lastname': _nameController.text.split(' ')[1],
      'faculty': _facultyController.text,
      'phone': _phoneController.text,
      'roomNum': _roomNumController.text,
    };

    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    setState(() {
      _isLoading = true; // เริ่มการโหลด
    });

    // ดำเนินการอัปเดตข้อมูลผู้ใช้
    AdminController().updateUser(token, userId, updatedUser).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')), // แสดงข้อความเมื่อบันทึกสำเร็จ
      );

      Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
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
