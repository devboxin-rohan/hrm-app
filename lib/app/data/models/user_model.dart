// user_model.dart
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final int? empId;

  @HiveField(4)
  final String? emailVerifiedAt;

  @HiveField(5)
  final String? biometricId;

  @HiveField(6)
  final int isActive;

  @HiveField(7)
  final int isMobileLogin;

  @HiveField(8)
  final String? mobileLoginCode;

  @HiveField(9)
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.empId,
    this.emailVerifiedAt,
    this.biometricId,
    required this.isActive,
    required this.isMobileLogin,
    this.mobileLoginCode,
    this.token,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      empId: json['emp_id'],
      emailVerifiedAt: json['email_verified_at'],
      biometricId: json["biometric_id"],
      isActive: json["is_active"],
      isMobileLogin: json["is_mobile_login"],
      mobileLoginCode: json["mobile_login_code"],
      token: json['token'],
    );
  }

  // Updated toJson method with specific key format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'emp_id': empId,
      'email_verified_at': emailVerifiedAt,
      'biometric_id': biometricId,
      'is_active': isActive,
      'is_mobile_login': isMobileLogin,
      'mobile_login_code': mobileLoginCode,
      'token': token,
    };
  }
}
