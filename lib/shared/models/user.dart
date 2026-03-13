/// User model
library;

import 'base_entity.dart';

class User extends BaseEntity {
  final String email;
  final String name;
  final String employeeId;
  final String department;
  final String designation;
  final String? phone;
  final String? profilePicture;
  final DateTime? lastLogin;

  User({
    required super.id,
    required this.email,
    required this.name,
    required this.employeeId,
    required this.department,
    required this.designation,
    this.phone,
    this.profilePicture,
    this.lastLogin,
    super.createdAt,
    super.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      employeeId: json['employeeId'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      phone: json['phone'],
      profilePicture: json['profilePicture'] ?? json['profilePictureUrl'],
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'email': email,
      'name': name,
      'employeeId': employeeId,
      'department': department,
      'designation': designation,
      'phone': phone,
      'profilePicture': profilePicture,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({String? email, String? name, String? phone, String? profilePicture}) {
    return User(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      employeeId: employeeId,
      department: department,
      designation: designation,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      lastLogin: lastLogin,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
