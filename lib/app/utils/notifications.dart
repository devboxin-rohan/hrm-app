import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/theme/app_colors.dart';

class AlertNotification {
  static void _showSnackbar(String heading, String description, {required Color colorText}) {
    // Check if a snackbar is currently active and close it
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    // Show the new snackbar
    Get.snackbar(
      heading,
      description,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.white,
      colorText: colorText,
    );
  }

  static void error(String heading, String description) {
    _showSnackbar(heading, description, colorText: AppColors.red);
  }

  static void success(String heading, String description) {
    _showSnackbar(heading, description, colorText: AppColors.green);
  }
}
