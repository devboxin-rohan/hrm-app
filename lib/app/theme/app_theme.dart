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
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5)),
          maximumSize: const Size(300, 45),
          minimumSize: const Size(300, 45),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.secondary,
          iconColor: AppColors.primary,
          prefixIconColor: AppColors.primary,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.primary,
                  style: BorderStyle.solid,
                  width: 2))),
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
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5)),
          maximumSize: const Size(300, 45),
          minimumSize: const Size(300, 45),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.secondary,
          iconColor: AppColors.primary,
          prefixIconColor: AppColors.primary,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.primary,
                  style: BorderStyle.solid,
                  width: 2)))
    
    
  );
}
