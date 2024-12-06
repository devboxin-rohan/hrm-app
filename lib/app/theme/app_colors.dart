import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromRGBO(239, 83, 80, 1);
  static const Color secondary = Color.fromRGBO(250, 241, 255, 1.0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color red = Color.fromRGBO(239, 83, 80, 1);
  static const Color green = Color.fromRGBO(100, 204, 69, 1);

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: AppColors.grey,
  );

   static const TextStyle subtitleBoldStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w800
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
  );

  static const TextStyle linkTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    fontWeight:FontWeight.w800
  );

  static const TextStyle primaryTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.primary,
  );

  // Add more colors as needed
}
