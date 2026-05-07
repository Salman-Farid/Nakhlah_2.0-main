import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class AppSnackbar {
  static void success(String m, {String title = 'Success'}) => Get.snackbar(
    title,
    m,
    backgroundColor: AppColors.success,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );

  static void error(String m, {String title = 'Error'}) => Get.snackbar(
    title,
    m,
    backgroundColor: AppColors.danger,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );

  static void info(String m, {String title = 'Nakhlah'}) => Get.snackbar(
    title,
    m,
    backgroundColor: AppColors.ink,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );
}
