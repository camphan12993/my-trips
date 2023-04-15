import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/core/app_pages.dart';
import 'package:my_trips_app/core/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  initInstances();
  runApp(const MyApp());
}

initInstances() {
  Get.put(AuthController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Trips',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary)),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(width: 1, color: AppColors.primary),
          ),
        ),
      ).copyWith(
        primaryColor: AppColors.primary,
      ),
      color: Colors.white,
      builder: EasyLoading.init(),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.initial,
    );
  }
}
