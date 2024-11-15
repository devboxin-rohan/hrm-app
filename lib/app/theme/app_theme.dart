import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.secondary,
    fontFamily: "roboto",
    // Use colorScheme to set your colors
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // You can define additional colors if needed
      background: AppColors.secondary,
      surface: AppColors.black, // Add if needed
      error: AppColors.black, // Add if needed
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    // Use colorScheme to set your colors
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: Colors.black,
      surface: AppColors.black, // Add if needed
      error: AppColors.black, // Add if needed
    ),
  );
}
