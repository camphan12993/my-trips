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
import '../auth/auth_controller.dart';

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
  RxBool isLoading = RxBool(false);
  var selectedDay = 1.obs;
  var currentDay = 2.obs;
  var bottomTabIndex = 0.obs;
  final AuthController _authController = Get.find();

  // edit mode
  var isEditPlace = false.obs;
  var isEditExpense = false.obs;

  // trip settings
  final TextEditingController startDateController = TextEditingController();
  Rxn<DateTime> formSelectedDate = Rxn();
  final RxnString selectedUser = RxnString();

  List<AppUser> get listUsers => users
      .where(
        (u) => !members.any((m) => m.uid == u.uid) && u.uid != _authController.user!.uid,
      )
      .toList();

  @override
  Future<void> onInit() async {
    super.onInit();
    id = Get.parameters['id'];
    if (id != null) {
      isLoading.value = true;
      await getTripById();
      await getTripNodes();
      await getListMember();
      await getUserList();
      if (trip.value != null) {
        members.clear();
        members.addAll(trip.value!.memberIds.map((id) => users.firstWhere((user) => user.uid == id)).toList());
        nameController.text = trip.value!.name;
        startDateController.text = trip.value!.startDate;
        try {
          formSelectedDate.value = DateTime.parse(trip.value!.startDate);
        } catch (e) {
          print(e);
        }
      }
      isLoading.value = false;
    }
  }

  TripNode get currentNode => tripNodes[selectedDay.value];

  Future<void> getUserList() async {
    var result = await _userService.getListUser();
    users.clear();
    users.addAll(result);
  }

  Future<void> getTripById() async {
    var result = await _tripService.getTripById(id: id!);
    if (result != null) {
      trip.value = result;
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

  AppUser? getMember(String id) {
    return members.firstWhere((m) => m.uid == id);
  }

  String getMemberName(String id) {
    return getMember(id)?.name ?? '';
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

  Map<String, dynamic> getTripPayload() {
    String adminId = _authController.user!.uid;
    var memberIds = members.map((m) => m.uid);
    return {
      'name': nameController.text,
      'startDate': startDateController.text,
      'memberIds': [...memberIds, adminId],
    };
  }

  Future<void> updateTrip() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await _tripService.updateTrip(
          id: id!,
          payload: getTripPayload(),
        );
        Get.back();
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }
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
