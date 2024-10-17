import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter042/providers/user_provider.dart';
import 'package:flutter042/controllers/admin_controller.dart'; // นำเข้า admin_controller

class AddMeetingRoomPage extends StatefulWidget {
  const AddMeetingRoomPage({super.key});

  @override
  _AddMeetingRoomPageState createState() => _AddMeetingRoomPageState();
}

class _AddMeetingRoomPageState extends State<AddMeetingRoomPage> {
  final _formKey = GlobalKey<FormState>(); // สำหรับจัดการฟอร์ม
  final TextEditingController _meetingRoomNumberController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  bool _isLoading = false;

  // สร้างอินสแตนซ์ของ AdminController
  late AdminController _adminController;

  @override
  void initState() {
    super.initState();
    _adminController = AdminController(); // กำหนดค่าให้กับ adminController
  }

// ฟังก์ชันที่ใช้เมื่อกดปุ่มเพิ่มห้องประชุม
void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    final String token = Provider.of<UserProvider>(context, listen: false).accessToken; // รับ token จาก Provider

    try {
      // เรียกฟังก์ชัน addRoom จาก adminController
      await _adminController.addRoom(
        token,
        _meetingRoomNumberController.text,
        _floorController.text,
      );

      // แสดงข้อความยืนยันเมื่อเพิ่มห้องประชุมสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting room added successfully!')),
      );

      // กลับไปยังหน้า RoomStatusPage
      Navigator.pop(context);
    } catch (e) {
      // แสดงข้อความเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add meeting room: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meeting Room',
                  style: TextStyle(
                      color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
                    ),
        backgroundColor: Colors.indigo[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ฟิลด์สำหรับกรอกหมายเลขห้องประชุม
              TextFormField(
                controller: _meetingRoomNumberController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Room Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meeting room number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ฟิลด์สำหรับกรอกชั้น
              TextFormField(
                controller: _floorController,
                decoration: const InputDecoration(
                  labelText: 'Floor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the floor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ปุ่มสำหรับเพิ่มห้องประชุม
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[700], // สีปุ่ม
                      ),
                      child: const Text('Add Room',
                  style: TextStyle(
                      color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _meetingRoomNumberController.dispose();
    _floorController.dispose();
    super.dispose();
  }
}
