import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/core/services/index.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = RxBool(false);
  final AuthService _authService = AuthService();

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      User? user = await _authService.createAccount(
        name: nameController.text,
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
