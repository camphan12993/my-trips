import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/core/app_routes.dart';

import '../firebase_options.dart';

class SplashController extends GetxController {
  RxBool isLoading = RxBool(false);

  Future<void> initFirebase() async {
    // init firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Get.offAndToNamed(AppRoutes.home);
    } else {
      Get.offAndToNamed(AppRoutes.login);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    await initFirebase();
    isLoading.value = false;
  }
}
