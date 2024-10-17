// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

List<BookingModel> bookingModelFromJson(String str) => List<BookingModel>.from(json.decode(str).map((x) => BookingModel.fromJson(x)));

String bookingModelToJson(List<BookingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingModel {
    String id;
    String bookingId;
    String meetingRoomNumber;
    String userId;
    DateTime bookingDate;
    String status;
    bool approved;

    BookingModel({
        required this.id,
        required this.bookingId,
        required this.meetingRoomNumber,
        required this.userId,
        required this.bookingDate,
        required this.status,
        required this.approved,
    });

    factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json["_id"],
        bookingId: json["bookingId"],
        meetingRoomNumber: json["MeetingRoomNumber"],
        userId: json["id"],
        bookingDate: DateTime.parse(json["bookingDate"]),
        status: json["status"],
        approved: json["approved"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bookingId": bookingId,
        "MeetingRoomNumber": meetingRoomNumber,
        "id": userId,
        "bookingDate": bookingDate.toIso8601String(),
        "status": status,
        "approved": approved,
    };
}








// class BookingModel {
//   final String id;
//   final String meetingRoomNumber;
//   final String userId;
//   final DateTime bookingDate;

//   BookingModel({
//     required this.id,
//     required this.meetingRoomNumber,
//     required this.userId,
//     required this.bookingDate,
//   });

//   factory BookingModel.fromJson(Map<String, dynamic> json) {
//     return BookingModel(
//       id: json['_id'] ?? 'Unknown ID',
//       meetingRoomNumber: json['MeetingRoomNumber'] != null 
//           ? (json['MeetingRoomNumber']['roomNumber'] ?? 'Unknown Room') 
//           : 'Unknown Room',
//       userId: json['userId'] != null ? (json['userId']['_id'] ?? 'Unknown User') : 'Unknown User',
//       bookingDate: json['bookingDate'] != null
//           ? DateTime.tryParse(json['bookingDate']) ?? DateTime.now()  // ใช้ tryParse เพื่อตรวจสอบการแปลงวันที่
//           : DateTime.now(), // กรณีที่ไม่มีค่า bookingDate ให้ใช้วันที่ปัจจุบัน
//     );
//   }
// }
