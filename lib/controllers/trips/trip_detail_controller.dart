import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/services/trip_service.dart';
import 'package:my_trips_app/models/add_plan_node_payload.dart';
import 'package:my_trips_app/models/trip_node.dart';

import '../../core/services/user_service.dart';
import '../../models/app_user.dart';
import '../../models/trip.dart';
import '../../models/trip_expense.dart';

class TripDetailController extends GetxController {
  String? id;
  Rxn<Trip> trip = Rxn<Trip>();
  RxList<TripNode> tripNodes = RxList([]);
  final TripService _tripService = TripService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final RxList<AppUser> members = RxList<AppUser>([]);
  RxList<AppUser> users = RxList([]);
  final UserService _userService = UserService();
  RxBool isShowDetail = RxBool(false);
  RxBool isLoading = RxBool(false);

  @override
  Future<void> onInit() async {
    super.onInit();
    id = Get.parameters['id'];
    if (id != null) {
      isLoading.value = true;
      await getTripById();
      if (trip.value != null) {
        getUserList();
      }
      await getTripNodes();
      isLoading.value = false;
    }
  }

  Future<void> getUserList() async {
    var result = await _userService.getListUser();
    users.clear();
    users.addAll(result);
    members.clear();
    members.addAll(trip.value!.memberIds.map((id) => users.firstWhere((user) => user.uid == id)).toList());
  }

  Future<void> getTripById() async {
    var result = await _tripService.getTripById(id: id!);
    if (result != null) {
      trip.value = result;
    }
  }

  Future<void> getTripNodes() async {
    var result = await _tripService.getListNodes(tripId: id!);
    tripNodes.clear();
    tripNodes.addAll(result);
  }

  Future<void> addNode() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addTripNode(
      tripId: id!,
      payload: {
        'name': nameController.text,
        'createdDate': DateTime.now().toUtc().toString(),
      },
    );
    getTripNodes();
    EasyLoading.dismiss();
  }

  double getTotalInNode(List<TripExpense> expenses) {
    double result = 0;
    for (var element in expenses) {
      result += element.value;
    }
    return result;
  }

  double getTotal() {
    double result = 0;
    for (var node in tripNodes) {
      result += getTotalInNode(node.expenses);
    }
    return result;
  }

  double getTotalOfMember(String id) {
    double result = 0;
    for (var node in tripNodes) {
      for (var e in node.expenses) {
        if (e.userId == id) {
          result += e.value;
        }
      }
    }
    return result;
  }

  Future<void> addExpend({
    required String nodeId,
    required String userId,
    required int value,
    required String name,
    required String time,
  }) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addExpense(nodeId: nodeId, payload: {
      'userId': userId,
      'value': value,
      'name': name,
      'time': time,
    });
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> addPlanNode(String nodeId, AddPlanNodePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addPlanNode(nodeId: nodeId, payload: payload.toMap());
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> updateExpend({
    required String nodeId,
    required String expenseId,
    required String userId,
    required int value,
    required String name,
    required String time,
  }) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.updateExpense(nodeId: nodeId, id: expenseId, payload: {
      'userId': userId,
      'value': value,
      'name': name,
      'time': time,
    });
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> deleteExpend({
    required String nodeId,
    required String expenseId,
  }) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.deleteExpense(nodeId: nodeId, id: expenseId);
    await getTripNodes();
    EasyLoading.dismiss();
  }
}
