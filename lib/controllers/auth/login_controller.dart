import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../core/app_routes.dart';
import '../../core/services/index.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = RxBool(false);
  final AuthService _authService = AuthService();

  Future<void> doLogin() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      User? user = await _authService.signInUsingEmailPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      EasyLoading.dismiss();
      if (user != null) {
        Get.offAndToNamed(AppRoutes.home);
      }
    }
  }
}
