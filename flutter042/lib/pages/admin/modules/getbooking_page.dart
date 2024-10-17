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
      body: RefreshIndicator(
        onRefresh: fetchBookings,
        child: _bookings.isNotEmpty
            ? ListView.builder(
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white, // เปลี่ยนพื้นหลังของ Card เป็นสีขาว
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ห้องประชุม: ${_bookings[index].meetingRoomNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black, // เปลี่ยนสีฟ้อนเป็นสีดำ
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'ผู้จอง: ${_bookings[index].userId}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black), // เปลี่ยนสีฟ้อนเป็นสีดำ
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'วันที่จอง: ${_bookings[index].bookingDate.toLocal()}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black), // เปลี่ยนสีฟ้อนเป็นสีดำ
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // เพิ่มการอนุมัติที่นี่
                              print("อนุมัตินะ");
                            },
                            icon: const Icon(Icons.check, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('ไม่มีข้อมูลการจอง'),
              ),
      ),
    );
  }
}
