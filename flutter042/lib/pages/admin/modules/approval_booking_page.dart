import 'package:flutter/material.dart';
import 'package:flutter042/controllers/admin_controller.dart';
import 'package:flutter042/varbles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApprovalBookingPage extends StatefulWidget {
  final String token;

  const ApprovalBookingPage({Key? key, required this.token}) : super(key: key);

  @override
  _ApprovalBookingPageState createState() => _ApprovalBookingPageState();
}

class _ApprovalBookingPageState extends State<ApprovalBookingPage> {
  List<dynamic> bookings = []; // ตัวแปรเก็บข้อมูลการจอง
  final AdminController adminController = AdminController(); // สร้างอินสแตนซ์ของ AdminController

  @override
  void initState() {
    super.initState();
    fetchBookings(); // เรียกใช้ฟังก์ชันดึงข้อมูลเมื่อเริ่มต้น
  }

  Future<void> fetchBookings() async {
    final response = await http.get(
      Uri.parse('$apiURL/api/booking/room/approve'), // URL ของ API
      headers: {
        'Authorization': 'Bearer ${widget.token}', // ใช้ token สำหรับการเข้าถึง
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        bookings = json.decode(response.body); // แปลง JSON และเก็บใน bookings
      });
    } else {
      // จัดการข้อผิดพลาดที่เกิดขึ้น
      print('Failed to load bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Booking'),
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator()) // แสดง loading ข้อมูล
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final user = booking.id; // ข้อมูลผู้ใช้ที่ populate มา

                return ListTile(
                  title: Text('Room: ${booking.MeetingRoomNumber}'),
                  subtitle: Text('Requested by: ${user.username} (${user.name})'), // แสดง username และ name
                  trailing: ElevatedButton(
                    onPressed: () {
                      // ฟังก์ชันสำหรับการอนุมัติการจอง
                      approveBooking(booking.MeetingRoomNumber); // ส่ง MeetingRoomNumber แทน bookingId
                    },
                    child: const Text('Approve'),
                  ),
                );
              },
            ),
    );
  }

  Future<void> approveBooking(String meetingRoomNumber) async {
    // เรียกใช้ฟังก์ชัน approveBooking จาก AdminController
    try {
      final response = await adminController.approveBooking(widget.token, meetingRoomNumber); // เปลี่ยน bookingId เป็น meetingRoomNumber

      if (response['success']) {
        // หากอนุมัติสำเร็จ ให้ดึงข้อมูลใหม่
        fetchBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking approved successfully!')),
        );
      } else {
        throw Exception('Failed to approve booking');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve booking')),
      );
    }
  }
}
