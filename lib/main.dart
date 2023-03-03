import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/app_pages.dart';
import 'package:my_trips_app/core/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.initial,
    );
  }
}
