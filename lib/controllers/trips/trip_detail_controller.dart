import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/app_constants.dart';
import 'package:my_trips_app/core/app_utils.dart';
import 'package:my_trips_app/core/services/trip_service.dart';
import 'package:my_trips_app/models/add_plan_node_payload.dart';
import 'package:my_trips_app/models/app_currency.dart';
import 'package:my_trips_app/models/expense_payload.dart';
import 'package:my_trips_app/models/trip_expense_payload.dart';
import 'package:my_trips_app/models/trip_member.dart';
import 'package:my_trips_app/models/trip_node.dart';

import '../../core/services/user_service.dart';
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
  final RxList<TripMember> members = RxList<TripMember>([]);
  final RxList<TripMember> membersDropdown = RxList<TripMember>([]);
  late NumberFormat formatCurrency;
  RxBool isLoading = RxBool(false);
  var selectedDay = 0.obs;
  var currentDay = (-1).obs;
  var bottomTabIndex = 0.obs;

  String memberName(String id) {
    return members.firstWhere((m) => m.id == id).name;
  }

  // trip settings
  final TextEditingController startDateController = TextEditingController();
  Rxn<DateTime> formSelectedDate = Rxn();
  final RxnString selectedMember = RxnString();
  var selectedCurrency = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    id = Get.parameters['id'];
    if (id != null) {
      isLoading.value = true;
      await getTripById();
      await getTripNodes();

      if (trip.value != null) {
        members.clear();
        members.addAll(trip.value!.members);
        nameController.text = trip.value!.name;
        startDateController.text = trip.value!.startDate;
        selectedCurrency.value = trip.value!.locale;
        getCurrentDay();
        if (currentDay.value > -1) {
          selectedDay.value = currentDay.value;
        }
        try {
          formSelectedDate.value = DateTime.parse(trip.value!.startDate);
        } catch (e) {
          print(e);
        }
      }
      await getUserList();
      isLoading.value = false;
    }
  }

  getCurrentDay() {
    DateTime start = DateTime.parse(trip.value!.startDate);
    DateTime now = DateTime.now();
    if (now.isAfter(start) || now.isAtSameMomentAs(start)) {
      int diff = now.difference(start).inDays;
      currentDay.value = diff >= tripNodes.length ? -1 : diff;
    }
  }

  Future<void> getUserList() async {
    var result = await _userService.getListUser();
    for (var u in result) {
      if (members.indexWhere((m) => m.id == u.uid) == -1) {
        membersDropdown.add(TripMember(id: u.uid, name: u.name));
      }
    }
  }

  Future<void> getTripById() async {
    var result = await _tripService.getTripById(id: id!);
    if (result != null) {
      trip.value = result;
      formatCurrency = AppUtils.formatCurrency(AppCurrency(local: trip.value!.locale, name: trip.value!.currency));
    }
  }

  void addMember(String id) {
    selectedMember.value = null;
    var member = membersDropdown.firstWhere((m) => m.id == id);
    membersDropdown.removeWhere((m) => m.id == id);
    members.add(member);
  }

  Future<void> addPayedExpense(Map<String, dynamic> payload) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.addTripPayedExpense(tripId: trip.value!.id, payload: payload);
    await getTripById();
    EasyLoading.dismiss();
  }

  void deleteMember(TripMember member) {
    members.remove(member);
    membersDropdown.add(member);
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
    await getTripNodes();
    getCurrentDay();
    selectedDay.value = tripNodes.length - 1;
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
    var currency = AppConstants.currencies.firstWhere((a) => a.local == selectedCurrency.value);
    return {
      'name': nameController.text,
      'startDate': DateFormat('yyyy-MM-dd').format(formSelectedDate.value!),
      'members': members.map((m) => m.toMap()),
      'currency': currency.name,
      'locale': currency.local,
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
        await getTripById();
        EasyLoading.dismiss();
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

  Future<void> deleteExpend(
    String nodeId,
    String expenseId,
  ) async {
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
