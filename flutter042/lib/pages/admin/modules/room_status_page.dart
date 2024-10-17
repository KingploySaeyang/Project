import 'package:flutter/material.dart';
import 'package:flutter042/controllers/admin_controller.dart';
import 'package:flutter042/models/room_model.dart' as room;
import 'addroom_page.dart'; // เพิ่มหน้าที่จะไป

class RoomStatusPage extends StatefulWidget {
  final String token;

  const RoomStatusPage({Key? key, required this.token}) : super(key: key);

  @override
  _RoomStatusPageState createState() => _RoomStatusPageState();
}

class _RoomStatusPageState extends State<RoomStatusPage> {
  late AdminController _controller;
  late Future<List<room.RoomModel>> futureRooms;

  @override
  void initState() {
    super.initState();
    _controller = AdminController();
    futureRooms = _controller.checkRoomStatus(widget.token).then((data) {
      return (data as List)
          .map((roomJson) => room.RoomModel.fromJson(roomJson))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถานะห้องประชุม'),
      ),
      body: FutureBuilder<List<room.RoomModel>>(
        future: futureRooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบห้องประชุม.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final room = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.white, // เปลี่ยนพื้นหลังของ Card เป็นสีขาว
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'หมายเลขห้องประชุม: ${room.meetingRoomNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'ชั้น: ${room.floor}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'สถานะ: ${room.status}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ปุ่มนี้ยังไม่มีฟังก์ชันการทำงาน')),
                            );
                          },
                          child: const Text('ดูข้อมูลการจอง'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMeetingRoomPage(), // ลิงค์ไปหน้าที่ต้องการ
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white), // ไอคอนบวกสีขาว
        backgroundColor: Colors.indigo[700], // สีปุ่มเป็นสีชมพู
      ),
    );
  }
}
