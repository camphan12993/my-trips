import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = RxBool(false);
  final AuthController _authController = Get.find();

  Future<void> doLogin() async {
    if (formKey.currentState!.validate()) {
      await _authController.doLogin(emailController.text, passwordController.text);
    }
  }
}
