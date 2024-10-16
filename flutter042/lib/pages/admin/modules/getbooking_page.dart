import 'package:flutter/material.dart';
import 'package:flutter042/controllers/admin_controller.dart';
import 'package:flutter042/models/booking_model.dart';

class GetBookingPage extends StatefulWidget {
  final String token; // กำหนด token ที่นี่

  const GetBookingPage({Key? key, required this.token}) : super(key: key);
  
  @override
  _GetBookingPageState createState() => _GetBookingPageState();
}

class _GetBookingPageState extends State<GetBookingPage> {
  final AdminController _controller = AdminController();
  List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings(); // เรียกใช้งานฟังก์ชันดึงข้อมูลการจอง
  }

  Future<void> fetchBookings() async {
    try {
      _bookings = await _controller.getBookings(); // ดึงข้อมูลการจอง
      setState(() {}); // อัปเดต UI หลังจากดึงข้อมูลสำเร็จ
    } catch (e) {
      print('Error fetching bookings: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch bookings: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายการการจอง')),
      body: _bookings.isNotEmpty
          ? ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('ห้องประชุม: ${_bookings[index].meetingRoomNumber}'),
                  subtitle: Text(
                    'ผู้จอง: ${_bookings[index].userId}\nวันที่จอง: ${_bookings[index].bookingDate.toLocal()}',
                  ),
                );
              },
            )
          : Center(
              child: Text('ไม่มีข้อมูลการจอง'),
            ),
    );
  }
}
