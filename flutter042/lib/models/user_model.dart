// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    User user;
    String accessToken;
    String refreshToken;
    String role;

    UserModel({
        required this.user,
        required this.accessToken,
        required this.refreshToken,
        required this.role,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "role": role,
    };
}

class User {
    String id;
    String userId;
    String password;
    String firstname;
    String lastname;
    String faculty;
    String phone;
    String roomNum;
    String role;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    User({
        required this.id,
        required this.userId,
        required this.password,
        required this.firstname,
        required this.lastname,
        required this.faculty,
        required this.phone,
        required this.roomNum,
        required this.role,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userId: json["id"],
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        faculty: json["faculty"],
        phone: json["phone"],
        roomNum: json["roomNum"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": userId,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "faculty": faculty,
        "phone": phone,
        "roomNum": roomNum,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
