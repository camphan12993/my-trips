import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/services/trip_service.dart';
import 'package:my_trips_app/models/add_plan_node_payload.dart';
import 'package:my_trips_app/models/expense_payload.dart';
import 'package:my_trips_app/models/trip_expense_payload.dart';
import 'package:my_trips_app/models/trip_node.dart';

import '../../core/services/user_service.dart';
import '../../models/app_user.dart';
import '../../models/trip.dart';
import '../../models/trip_expense.dart';

class TripDetailController extends GetxController {
  String? id;
  Rxn<Trip> trip = Rxn<Trip>();
  RxList<TripNode> tripNodes = RxList([]);
  RxList<TripNode> displayedTripNodes = RxList([]);
  final TripService _tripService = TripService();
  final UserService _userService = UserService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final RxList<AppUser> members = RxList<AppUser>([]);
  RxList<AppUser> users = RxList([]);
  RxBool isShowDetail = RxBool(false);
  RxBool isLoading = RxBool(false);
  var selectedDate = -1.obs;
  var selectedTab = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    id = Get.parameters['id'];
    if (id != null) {
      isLoading.value = true;
      await getTripById();
      await getTripNodes();
      await getListMember();
      isLoading.value = false;
    }
  }

  Future<void> getTripById() async {
    var result = await _tripService.getTripById(id: id!);
    if (result != null) {
      trip.value = result;
    }
  }

  void onSelectDate(int value) {
    displayedTripNodes.clear();
    selectedDate = value;
    if (value == -1) {
      displayedTripNodes.addAll(tripNodes);
    } else {
      displayedTripNodes.add(tripNodes[value]);
    }
  }

  AppUser getMember(String id) {
    return members.firstWhere((m) => m.uid == id);
  }

  Future<void> getListMember() async {
    var result = await _userService.getListMember(trip.value!.memberIds);
    members.clear();
    members.addAll(result);
  }

  Future<void> getTripNodes() async {
    var result = await _tripService.getListNodes(tripId: id!);
    tripNodes.clear();
    tripNodes.addAll(result);
    onSelectDate(selectedDate);
  }

  Future<void> addNode() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addTripNode(
      tripId: id!,
    );
    getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> deleteNode(String id) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.deleteNode(id);
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
    result += getTotalInNode(trip.value!.otherExpense);
    return result;
  }

  int eachMember() {
    var total = getTotal();
    return (total / members.length).round();
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
    for (var e in trip.value!.otherExpense) {
      if (e.userId == id) {
        result += e.value;
      }
    }
    return result;
  }

  Future<void> addExpend(ExpensePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addExpense(nodeId: payload.nodeId, payload: payload.toMap());
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> addTripExpense(TripExpensePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addTripOtherExpense(tripId: trip.value!.id, payload: payload.toMap());
    await getTripById();
    EasyLoading.dismiss();
  }

  Future<void> updateTripExpense(String id, TripExpensePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.updateTripOtherExpense(tripId: trip.value!.id, id: id, payload: payload.toMap());
    await getTripById();
    EasyLoading.dismiss();
  }

  Future<void> addPlanNode(String nodeId, AddPlanNodePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addPlanNode(nodeId: nodeId, payload: payload.toMap());
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> deletePlanNode(String nodeId, String id) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.deletePlanNode(nodeId: nodeId, id: id);
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> updatePlanNode(String nodeId, String id, AddPlanNodePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.updatePlanNode(nodeId: nodeId, id: id, payload: payload.toMap());
    await getTripNodes();
    EasyLoading.dismiss();
  }

  Future<void> updateExpend(String id, ExpensePayload payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.updateExpense(nodeId: payload.nodeId, id: id, payload: payload.toMap());
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

  Future<void> deleteTripExpense(String id) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.deleteTripOtherExpense(tripId: trip.value!.id, id: id);
    await getTripById();
    EasyLoading.dismiss();
  }
}
