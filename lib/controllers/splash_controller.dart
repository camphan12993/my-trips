import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';

class SplashController extends GetxController {
  RxBool isLoading = RxBool(false);
  final AuthController _authController = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    await _authController.initFirebase();
    isLoading.value = false;
  }
}
