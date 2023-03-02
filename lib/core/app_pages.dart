import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/screens/index.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => SplashController());
        },
      ),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const Home(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => HomeController());
        },
      ),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const Login(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => LoginController());
        },
      ),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const Register(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => RegisterController());
        },
      ),
    ),
  ];
}
