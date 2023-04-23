import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/core/services/index.dart';
import 'package:my_trips_app/core/services/storage_service.dart';
import 'package:my_trips_app/models/app_user.dart';

import '../../core/app_routes.dart';
import '../../firebase_options.dart';

class AuthController extends GetxController {
  AppUser? user;
  final AuthService _authService = AuthService();

  RxBool isLoading = RxBool(false);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  onReady() async {
    isLoading.value = true;
    await initFirebase();
    await checkLogin();

    isLoading.value = false;
  }

  Future<void> doLogin(String email, String password) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    user = await _authService.signInUsingEmailPassword(email: email, password: password);
    EasyLoading.dismiss();
    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> checkLogin() async {
    var userString = Storage.getValue('user');
    if (userString != null) {
      user = AppUser.fromJson(userString);
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.usernameLogin);
    }
  }

  Future<void> loginUsername(String username) async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      user = await _authService.loginUsername(username: username);
      EasyLoading.dismiss();
      if (user != null) {
        Get.offAllNamed(AppRoutes.home);
        Storage.user = user;
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> registerUsername({required String username, required String name}) async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      user = await _authService.createUsernameAccount(
        name: name,
        username: username,
      );
      Storage.user = user;
      EasyLoading.dismiss();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  Future<void> signout() async {
    user = null;
    Storage.clear();
    Get.offAllNamed(AppRoutes.usernameLogin);
  }

  Future<void> initFirebase() async {
    // init firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // User? firebaseUser = FirebaseAuth.instance.currentUser;
    // if (firebaseUser != null) {
    //   user = await _userService.getUserById(firebaseUser.uid);
    //   if (user != null) {
    //     Get.offAndToNamed(AppRoutes.home);
    //   } else {
    //     Get.offAndToNamed(AppRoutes.login);
    //   }
    // } else {
    //   Get.offAndToNamed(AppRoutes.login);
    // }
  }
}
