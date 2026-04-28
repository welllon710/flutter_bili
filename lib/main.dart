import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:get/get.dart';
import 'package:get_demo/app/core/network/dio_client.dart';
import 'package:get_demo/app/core/theme/theme_controller.dart';
import 'package:get_demo/app/core/theme/theme_data.dart';
import 'package:media_kit/media_kit.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await WooHttpUtil().initSessionContext();
  Get.put(ThemeController(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      builder: FlutterSmartDialog.init(),
      navigatorObservers: <NavigatorObserver>[FlutterSmartDialog.observer],
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
