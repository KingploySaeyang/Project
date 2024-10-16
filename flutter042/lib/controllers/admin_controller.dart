import 'dart:convert';
import 'package:flutter042/models/booking_model.dart';
import 'package:flutter042/varbles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter042/models/user_model.dart';

class AdminController {
  // ฟังก์ชันสำหรับเพิ่มห้องประชุม
  Future<void> addRoom(String token, String roomNumber, String floor) async {
  final response = await http.post(
    Uri.parse('$apiURL/api/booking/rooms'), // เปลี่ยน URL เป็น URL ของ API
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'roomNumber': roomNumber,
      'floor': floor,
      // ไม่ต้องส่ง status เพราะจะตั้งค่าเป็นว่างในฐานข้อมูล
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add meeting room: ${response.body}');
  }
}

  // ฟังก์ชันสำหรับจองห้องประชุม
  Future<Map<String, dynamic>> bookingRoom(String token, String meetingRoomNumber, String userId, String bookingDate) async {
    try {
      // Validate ข้อมูลก่อน
      if (meetingRoomNumber.isEmpty || userId.isEmpty || bookingDate.isEmpty) {
        throw Exception('All fields are required for booking');
      }

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
    } catch (e) {
      print('Error occurred while booking room: $e');
      return {'success': false, 'message': e.toString()}; // ส่งข้อผิดพลาดกลับ
    }
  }

  // ฟังก์ชันสำหรับตรวจสอบสถานะของห้องประชุม
  Future<List<dynamic>> checkRoomStatus(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/booking/room/status'), // URL API สำหรับตรวจสอบสถานะห้อง
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load room status');
      }
    } catch (e) {
      print('Error occurred while checking room status: $e');
      throw Exception('Failed to load room status: $e');
    }
  }

  // ฟังก์ชันสำหรับอนุมัติการจองห้องประชุม
  Future<Map<String, dynamic>> approveBooking(String token, String meetingRoomNumber) async {
    try {
      if (meetingRoomNumber.isEmpty) {
        throw Exception('Meeting room number is required');
      }

      final response = await http.patch(
        Uri.parse('$apiURL/api/booking/room/approve'), // URL API สำหรับอนุมัติการจอง
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'MeetingRoomNumber': meetingRoomNumber}),
      );

      print('Approve Booking Response status: ${response.statusCode}');
      print('Approve Booking Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('Error occurred while approving booking: $e');
      return {'success': false, 'message': e.toString()}; // ส่งข้อผิดพลาดกลับ
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

        return jsonData.map((bookingJson) {
          return BookingModel.fromJson(bookingJson);
        }).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print('Exception occurred while fetching bookings: $e');
      throw Exception('Failed to load booking details: $e');
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้ทั้งหมด
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/booking/users'), // URL API สำหรับดึงข้อมูลผู้ใช้
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((userJson) {
          return User.fromJson(userJson as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error occurred while fetching users: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูลผู้ใช้
  Future<Map<String, dynamic>> updateUser(String token, String userId, Map<String, dynamic> updateData) async {
    try {
      if (userId.isEmpty || updateData.isEmpty) {
        throw Exception('User ID and update data are required');
      }

      final response = await http.put(
        Uri.parse('$apiURL/api/auth/users/$userId'), // URL API สำหรับอัปเดตผู้ใช้
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updateData),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error occurred while updating user: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ฟังก์ชันสำหรับลบผู้ใช้
  Future<Map<String, dynamic>> deleteUser(String token, String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID is required');
      }

      final response = await http.delete(
        Uri.parse('$apiURL/api/users/$userId'), // URL API สำหรับลบผู้ใช้
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error occurred while deleting user: $e');
      return {'success': false, 'message': e.toString()};
    }
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
