import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_demo/app/core/theme/theme_controller.dart';
import 'package:get_demo/app/core/theme/theme_data.dart';

import 'app/routes/app_pages.dart';

void main() {
  Get.put(ThemeController(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
