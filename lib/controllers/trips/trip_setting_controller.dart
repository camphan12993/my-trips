import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/services/user_service.dart';
import 'package:my_trips_app/models/app_user.dart';

import '../../core/services/trip_service.dart';
import '../../models/trip.dart';
import '../index.dart';

class TripSettingController extends GetxController {
  final TripDetailController _tripDetailController = Get.find();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TripService _tripService = TripService();
  final UserService _userService = UserService();
  RxList<AppUser> users = RxList([]);

  Trip get trip => _tripDetailController.trip.value!;

  @override
  void onInit() {
    super.onInit();
    var trip = _tripDetailController.trip.value;
    nameController.text = trip!.name;
    getUserList();
  }

  Future<void> getUserList() async {
    var result = await _userService.getListUser();
    users.clear();
    users.addAll(result);
  }

  Future<void> updateTrip() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await _tripService.updateTrip(
          id: _tripDetailController.id!,
          payload: {
            'name': nameController.text,
          },
        );
        Get.back();
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }
  }
}
