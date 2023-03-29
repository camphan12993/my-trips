import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';

class UsernameLoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  RxBool isLoading = RxBool(false);
  final AuthController _authController = Get.find();

  Future<void> doLogin() async {
    if (formKey.currentState!.validate()) {
      await _authController.loginUsername(usernameController.text);
    }
  }
}
