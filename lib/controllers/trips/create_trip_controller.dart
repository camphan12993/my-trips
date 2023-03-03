import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/services/trip_service.dart';

class CreateTripController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TripService _tripService = TripService();
  final AuthController _authController = Get.find();
  Future<void> create() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await _tripService.createTrip(name: nameController.text, adminId: _authController.user!.uid);
        Get.back();
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }
  }
}
