import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/screens/auth/username_login.dart';
import 'package:my_trips_app/screens/auth/username_register.dart';
import 'package:my_trips_app/screens/index.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
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
      name: AppRoutes.userProfile,
      page: () => const UserProfile(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => UserProfileController());
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
      name: AppRoutes.usernameLogin,
      page: () => const UsernameLogin(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => UsernameLoginController());
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
    GetPage(
      name: AppRoutes.usernameRegister,
      page: () => const UsernameRegister(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => UsernameRegisterController());
        },
      ),
    ),
    GetPage(
      name: AppRoutes.tripDetail,
      page: () => TripDetail(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => TripDetailController());
        },
      ),
    ),
  ];
}
