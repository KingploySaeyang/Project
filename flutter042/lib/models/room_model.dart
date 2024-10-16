import 'dart:convert';

RoomModel roomModel(String str) => RoomModel.fromJson(json.decode(str));

String roomModelToJson(RoomModel data) => json.encode(data.toJson());

class RoomModel {
  final String id;
  final String meetingRoomNumber;
  final String floor;
  final String status;

  RoomModel({
    required this.id,
    required this.meetingRoomNumber,
    required this.floor,
    required this.status,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'],
      meetingRoomNumber: json['MeetingRoomNumber'],
      floor: json['floor'],
      status: json['status'],
    );
  }
  // เพิ่มเมธอด toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meetingRoomNumber': meetingRoomNumber,
      'floor': floor,
      'status': status,
    };
  }
}

// models/booking_model.dart
class BookingModel {
  final String id;
  final String meetingRoomNumber;
  final String userId;
  final DateTime bookingDate;
  final String status;

  BookingModel({
    required this.id,
    required this.meetingRoomNumber,
    required this.userId,
    required this.bookingDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    var floor;
    return {
      'id': id,
      'meetingRoomNumber': meetingRoomNumber,
      'floor': floor,
      'status': status,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      meetingRoomNumber: json['MeetingRoomNumber'],
      userId: json['id'],
      bookingDate: DateTime.parse(json['bookingDate']),
      status: json['status'],
    );
  }
}
