import 'dart:convert';
import 'package:flutter042/models/booking_model.dart';
import 'package:flutter042/varbles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter042/models/user_model.dart';

class AdminController {
  // ฟังก์ชันสำหรับเพิ่มห้องประชุม
  Future<Map<String, dynamic>> addRoom(String token, String meetingRoomNumber, String floor, String status) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/rooms'), // URL API สำหรับเพิ่มห้องประชุม
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'MeetingRoomNumber': meetingRoomNumber,
        'floor': floor,
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // ฟังก์ชันสำหรับจองห้องประชุม
  Future<Map<String, dynamic>> bookingRoom(String token, String meetingRoomNumber, String userId, String bookingDate) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/booking/room/booking'), // URL API สำหรับจองห้องประชุม
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'MeetingRoomNumber': meetingRoomNumber,
        'id': userId,
        'bookingDate': bookingDate,
      }),
    );

    return _handleResponse(response);
  }

// ฟังก์ชันสำหรับตรวจสอบสถานะของห้องประชุม
Future<List<dynamic>> checkRoomStatus(String token) async {
  final response = await http.get(
    Uri.parse('$apiURL/api/booking/room/status'), // URL API สำหรับตรวจสอบสถานะห้อง
    headers: {
      'Authorization': 'Bearer $token', // เพิ่ม headers สำหรับ Authorization
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load room status');
  }
}


 // ฟังก์ชันสำหรับอนุมัติการจองห้องประชุม
Future<Map<String, dynamic>> approveBooking(String token, String meetingRoomNumber) async {
  try {
    final response = await http.patch(
      Uri.parse('$apiURL/api/booking/room/approve'), // URL API สำหรับอนุมัติการจอง
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'MeetingRoomNumber': meetingRoomNumber}), // ส่ง MeetingRoomNumber แทน bookingId
    );

    // ตรวจสอบสถานะและพิมพ์ข้อความ
    print('Approve Booking Response status: ${response.statusCode}');
    print('Approve Booking Response body: ${response.body}');

    // ใช้ฟังก์ชัน _handleResponse เพื่อจัดการการตอบสนอง
    return _handleResponse(response);
  } catch (e) {
    print('Error occurred while approving booking: $e');
    return {'success': false, 'message': e.toString()}; // ส่งค่าข้อความที่เกิดขึ้นกลับ
  }
}


// ฟังก์ชันสำหรับดึงข้อมูลการจองห้องประชุม
Future<List<BookingModel>> getBookings() async {
  try {
    final response = await http.get(
      Uri.parse('$apiURL/api/room/bookings'), // URL API สำหรับดึงข้อมูลการจอง
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      // แปลงข้อมูล JSON เป็น BookingModel
      return jsonData.map((bookingJson) {
        return BookingModel.fromJson(bookingJson);
      }).toList();
    } else {
      print('Failed to load bookings: ${response.body}');
      throw Exception('Failed to load booking details');
    }
  } catch (error) {
    // แสดงข้อผิดพลาดที่เกิดขึ้นใน terminal
    print('Exception occurred: $error');
    throw Exception('Failed to load booking details: $error');
  }
}

  // ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้ทั้งหมด
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$apiURL/api/booking/users'), // URL API สำหรับดึงข้อมูลผู้ใช้
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      // แปลงเป็น List<User>
      return jsonResponse.map((userJson) {
        return User.fromJson(userJson as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูลผู้ใช้
  Future<Map<String, dynamic>> updateUser(String token, String userId, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/users/$userId'), // URL API สำหรับอัปเดตผู้ใช้
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(updateData),
    );

    return _handleResponse(response);
  }

  // ฟังก์ชันสำหรับลบผู้ใช้
  Future<Map<String, dynamic>> deleteUser(String token, String userId) async {
    final response = await http.delete(
      Uri.parse('$apiURL/api/users/$userId'), // URL API สำหรับลบผู้ใช้
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  // ฟังก์ชันสำหรับจัดการการตอบสนอง
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error: ${response.body}');
    }
  }
}
