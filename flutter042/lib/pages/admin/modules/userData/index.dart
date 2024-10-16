import 'package:flutter/material.dart';
import 'package:flutter042/controllers/admin_controller.dart';
import 'package:flutter042/models/user_model.dart';
import 'package:flutter042/pages/admin/modules/userData/edit.dart';
import 'package:flutter042/pages/admin/modules/userData/view.dart';
import 'package:flutter042/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserTab extends StatelessWidget {
  const UserTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserProvider>(context).accessToken;
    return UserList(token: token);
  }
}

class UserList extends StatefulWidget {
  final String token;

  const UserList({required this.token, Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late AdminController _controller;
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    _controller = AdminController();
    futureUsers = _controller.getUsers().then((value) {
      return value.cast<User>(); // แปลงเป็น List<User>
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshUsers,
      child: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.pink[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstname} ${user.lastname}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'User ID: ${user.userId}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.pink),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // สร้าง UserModel จาก User ที่คุณมี
                                UserModel userModel = UserModel(
                                  user: user, // ส่ง User
                                  accessToken: widget
                                      .token, // ส่ง token หรือข้อมูลอื่นๆ ตามที่ต้องการ
                                  refreshToken:
                                      '', // กำหนดค่าให้เป็นค่าว่างหรือข้อมูลที่เกี่ยวข้อง
                                  role:
                                      '', // กำหนดค่าให้เป็นค่าว่างหรือข้อมูลที่เกี่ยวข้อง
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailPage(userModel: userModel),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text('View Details',
                                  style: TextStyle(color: Colors.pink)),
                            ),
                            ElevatedButton(
  onPressed: () {
    // สร้าง UserModel จาก User ที่คุณมี
    UserModel userModel = UserModel(
      user: user, // ส่ง User
      accessToken: widget.token, // ส่ง token หรือข้อมูลอื่นๆ ตามที่ต้องการ
      refreshToken: '', // กำหนดค่าให้เป็นค่าว่างหรือข้อมูลที่เกี่ยวข้อง
      role: '', // กำหนดค่าให้เป็นค่าว่างหรือข้อมูลที่เกี่ยวข้อง
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(user: userModel), // เปลี่ยนเป็น userModel
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
  ),
  child: const Text('Edit', style: TextStyle(color: Colors.pink)),
),

                            ElevatedButton(
                              onPressed: () {
                                _showDeleteDialog(user);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
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
    );
  }

  Future<void> _refreshUsers() async {
    setState(() {
      futureUsers = _controller.getUsers().then((value) {
        return value.cast<User>();
      });
    });
  }

  void _showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text(
              'Are you sure you want to delete ${user.firstname} ${user.lastname}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(user);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(User user) async {
    await _controller.deleteUser(widget.token, user.userId);
    setState(() {
      futureUsers = _controller.getUsers().then((value) {
        return value.cast<User>();
      });
    });
  }
}
