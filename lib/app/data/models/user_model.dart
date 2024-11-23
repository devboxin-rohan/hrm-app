// user_model.dart
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final int? empId;

  @HiveField(3)
  final String? emailVerifiedAt;

  @HiveField(4)
  final String? biometricId;

  @HiveField(5)
  final int isActive;

  @HiveField(6)
  final int? isMobileLogin;

  @HiveField(7)
  final String? mobileLoginCode;

  @HiveField(8)
  final String? token;

  UserModel({
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
      name: json['name'],
      email: json['email'],
      empId: json['id'],
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
