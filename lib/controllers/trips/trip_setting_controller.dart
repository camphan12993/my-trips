import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/models/app_user.dart';

import '../../core/services/trip_service.dart';
import '../../models/trip.dart';
import '../index.dart';

class TripSettingController extends GetxController {
  final TripDetailController _tripDetailController = Get.find();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final RxnString selectedUser = RxnString();
  final TripService _tripService = TripService();
  final RxList<AppUser> members = RxList<AppUser>([]);
  final RxList<AppUser> users = RxList<AppUser>([]);

  Trip get trip => _tripDetailController.trip.value!;

  @override
  void onInit() {
    super.onInit();
    var trip = _tripDetailController.trip.value;
    users.addAll(_tripDetailController.users);
    if (trip != null) {
      members.clear();
      members.addAll(trip.memberIds.map((id) => users.firstWhere((user) => user.uid == id)).toList());
      nameController.text = trip.name;
    }
  }

  void addMember(String id) {
    var user = users.firstWhere((user) => user.uid == id);
    members.add(user);
    selectedUser.value = null;
  }

  Future<void> updateTrip() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await _tripService.updateTrip(
          id: _tripDetailController.id!,
          payload: {'name': nameController.text, 'memberIds': members.map((e) => e.uid)},
        );
        Get.back();
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }
  }
}
