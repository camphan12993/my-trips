import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/core/services/index.dart';
import 'package:my_trips_app/core/services/user_service.dart';
import 'package:my_trips_app/models/app_user.dart';

import '../../core/app_routes.dart';
import '../../firebase_options.dart';

class AuthController extends GetxController {
  AppUser? user;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Future<void> doLogin(String email, String password) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    user = await _authService.signInUsingEmailPassword(email: email, password: password);
    EasyLoading.dismiss();
    if (user != null) {
      Get.offAndToNamed(AppRoutes.home);
    }
  }

  Future<void> initFirebase() async {
    // init firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      user = await _userService.getUserById(firebaseUser.uid);
      if (user != null) {
        Get.offAndToNamed(AppRoutes.home);
      } else {
        Get.offAndToNamed(AppRoutes.login);
      }
    } else {
      Get.offAndToNamed(AppRoutes.login);
    }
  }
}
