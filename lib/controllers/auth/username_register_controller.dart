import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';

class UsernameRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  RxBool isLoading = RxBool(false);
  final AuthController _authController = Get.find();

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      return await _authController.registerUsername(
        name: nameController.text,
        username: usernameController.text,
      );
    }
  }
}
