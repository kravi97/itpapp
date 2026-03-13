import 'user.dart';

class UserProfile extends User {
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? profileImageUrl;
  final String? bio;
  final String? manager;
  final String? joinDate;

  UserProfile({
    required super.id,
    required super.name,
    required super.email,
    required super.employeeId,
    required DateTime super.createdAt,
    required DateTime super.updatedAt,
    required super.designation,
    required super.department,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.profileImageUrl,
    this.bio,
    this.manager,
    this.joinDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      employeeId: json['employeeId'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      designation: json['designation'] ?? '',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postalCode'],
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'],
      manager: json['manager'],
      joinDate: json['joinDate'],
      department: json['department'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'manager': manager,
      'joinDate': joinDate,
      'department': department,
    };
  }
}
