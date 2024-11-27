import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.secondary,
    fontFamily: "roboto",
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.secondary,
      // surface: AppColors.black,
      // error: AppColors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // Set the background color
        foregroundColor: Colors.white, // Set the text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
        ),
      ),
    ),
    dialogBackgroundColor: AppColors.white,

  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    // scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // background: Colors.black,
      // surface: AppColors.black,
      // error: AppColors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary, // Set background for dark theme
        // foregroundColor: Colors.black, // Set text color for contrast
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
  );
}
