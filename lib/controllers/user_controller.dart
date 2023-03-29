import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/services/user_service.dart';
import 'package:my_trips_app/models/app_user.dart';

class UserProfileController extends GetxController {
  final AuthController _authController = Get.find();
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  AppUser get user => _authController.user!;
  final UserService _userService = UserService();
  Future<void> updateUser() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      await _userService.updateUser(
        id: user.uid,
        payload: {'name': nameController.text},
      );
      EasyLoading.dismiss();
    }
  }

  Future<void> signout() async {
    await _authController.signout();
  }

  @override
  void onInit() {
    super.onInit();
    nameController.text = user.name;
  }
}
