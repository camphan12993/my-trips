import 'package:get/get.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/core/services/index.dart';

class HomeController extends GetxController {
  AuthService authService = AuthService();
  Future<void> signout() async {
    await authService.signOut();
    Get.offAndToNamed(AppRoutes.login);
  }
}
