import 'package:flutter/material.dart';
import 'package:flutter042/models/user_model.dart';
import 'package:flutter042/models/room_model.dart' as roomModel;
import 'package:flutter042/models/booking_model.dart' as bookingModel;
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบวันที่

class BookingDetailsPage extends StatelessWidget {
  final UserModel userModel;
  final bookingModel.BookingModel booking;
  final roomModel.RoomModel room;

  const BookingDetailsPage({
    required this.userModel,
    required this.booking,
    required this.room,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // แปลง DateTime เป็น String โดยใช้ DateFormat
    final String formattedBookingDate = DateFormat('yyyy-MM-dd').format(booking.bookingDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('${userModel.user.firstname} ${userModel.user.lastname}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(150.0),
                1: FixedColumnWidth(200.0),
              },
              children: [
                TableRow(
                  children: [
                    const Text(
                      'Meeting Room Number:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(booking.meetingRoomNumber),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Floor:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(room.floor),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Date:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // ใช้วันที่ที่ถูกจัดรูปแบบแล้ว
                    Text(formattedBookingDate),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'User ID:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.userId),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'First Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.firstname),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Last Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.lastname),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Faculty:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.faculty),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Phone:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.phone),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Room Number:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userModel.user.roomNum),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
