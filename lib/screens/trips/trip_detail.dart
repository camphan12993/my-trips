import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/dialogs/add_spend_dialog.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/models/trip_expense.dart';
import 'package:my_trips_app/models/trip_node.dart';
import 'package:my_trips_app/screens/trips/components/trip_day_plan.dart';
import 'package:my_trips_app/screens/trips/components/trip_total_expense.dart';

import 'components/trip_settings.dart';

class TripDetail extends GetView<TripDetailController> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);
  TripDetail({super.key});

  Widget buildExpenseItem(TripExpense data, [String? nodeId]) {
    var member = controller.getMember(data.userId);
    return GestureDetector(
      onLongPress: () {
        Get.dialog(AddSpendDialog(
          nodeId: nodeId,
          expense: data,
        ));
      },
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // SizedBox(
                //   width: 20,
                //   child: Checkbox(
                //     value: data.hasPaid,
                //     onChanged: (value) {},
                //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   ),
                // ),
                // const SizedBox(
                //   width: 6,
                // ),
                Text(
                  '(${member.name})',
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  data.name,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(child: SizedBox.shrink()),
                Text(
                  formatCurrency.format(data.value),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            if (data.note.isNotEmpty) ...[
              const SizedBox(
                height: 6,
              ),
              Text(
                '(${data.note})',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildPlanItem(TripNode node, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.09),
            offset: Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ngày ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 10,
                  spreadRadius: -4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    switch (controller.bottomTabIndex.value) {
      case 0:
        return TripDayPlan();
      case 1:
        return TripTotalExpense();
      case 2:
        return TripSettings();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (controller.trip.value != null) {
        return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  controller.trip.value!.name,
                ),
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back)),
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.primary,
                actions: [
                  if (controller.bottomTabIndex.value == 0)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), spreadRadius: 0, blurRadius: 12),
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.train), label: 'Lịch trình'),
                BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Chi Phí'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
              ],
              currentIndex: controller.bottomTabIndex.value,
              onTap: (value) {
                controller.bottomTabIndex.value = value;
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 28, left: 24, right: 24),
                      child: buildBody()),
                ),
              ],
            ));
      }
      return const Scaffold(
        body: Center(
          child: Text('No Data'),
        ),
      );
    });
  }
}
