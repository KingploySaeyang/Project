class BookingModel {
  final String id;
  final String meetingRoomNumber;
  final String userId;
  final DateTime bookingDate;

  BookingModel({
    required this.id,
    required this.meetingRoomNumber,
    required this.userId,
    required this.bookingDate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? 'Unknown ID',
      meetingRoomNumber: json['MeetingRoomNumber'] != null 
          ? (json['MeetingRoomNumber']['roomNumber'] ?? 'Unknown Room') 
          : 'Unknown Room',
      userId: json['userId'] != null ? (json['userId']['_id'] ?? 'Unknown User') : 'Unknown User',
      bookingDate: json['bookingDate'] != null
          ? DateTime.tryParse(json['bookingDate']) ?? DateTime.now()  // ใช้ tryParse เพื่อตรวจสอบการแปลงวันที่
          : DateTime.now(), // กรณีที่ไม่มีค่า bookingDate ให้ใช้วันที่ปัจจุบัน
    );
  }
}
