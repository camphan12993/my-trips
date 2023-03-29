import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/services/trip_service.dart';
import 'package:my_trips_app/core/services/user_service.dart';

import '../../models/app_user.dart';
import '../../models/trip.dart';

class CreateTripController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TripService _tripService = TripService();
  final UserService _userService = UserService();
  final AuthController _authController = Get.find();
  final RxList<AppUser> members = RxList<AppUser>([]);
  final RxnString selectedUser = RxnString();
  final RxList<AppUser> users = RxList<AppUser>([]);
  Trip? trip;
  Rxn<DateTime> selectedDate = Rxn();

  @override
  Future<void> onInit() async {
    super.onInit();
    trip = Get.arguments?['trip'];
    await getUserList();
    if (trip != null) {
      members.clear();
      members.addAll(trip!.memberIds.map((id) => users.firstWhere((user) => user.uid == id)).toList());
      nameController.text = trip!.name;
      startDateController.text = trip!.startDate;
      try {
        selectedDate.value = DateTime.parse(trip!.startDate);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getUserList() async {
    var result = await _userService.getListUser();
    users.clear();
    users.addAll(result);
  }

  List<AppUser> get listUsers => users
      .where(
        (u) => !members.any((m) => m.uid == u.uid) && u.uid != _authController.user!.uid,
      )
      .toList();

  Future<void> create() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await _tripService.createTrip(getTripPayload());
        Get.back();
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }
  }

  Map<String, dynamic> getTripPayload() {
    String adminId = _authController.user!.uid;
    var memberIds = members.map((m) => m.uid);
    return {
      'name': nameController.text,
      'adminId': adminId,
      'startDate': startDateController.text,
      'memberIds': trip == null ? [...memberIds, adminId] : memberIds,
    };
  }

  Future<void> updateTrip() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await _tripService.updateTrip(
          id: trip!.id,
          payload: getTripPayload(),
        );
        Get.back();
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }
  }

  void addMember(String id) {
    var user = users.firstWhere((user) => user.uid == id);
    members.add(user);
    selectedUser.value = null;
  }

  void deleteMember(String id) {
    members.removeWhere((m) => m.uid == id);
  }
}
