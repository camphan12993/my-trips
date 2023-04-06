import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/dialogs/add_plan_node.dart';
import 'package:my_trips_app/dialogs/add_spend_dialog.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/models/trip_expense.dart';
import 'package:my_trips_app/models/trip_node.dart';
import 'package:my_trips_app/widgets/app_icon_button.dart';
import 'package:my_trips_app/widgets/expansion_panel.dart';

import '../../widgets/data_placeholder.dart';

class TripDetail extends GetView<TripDetailController> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);
  TripDetail({super.key});

  Widget buildExpenseDetailForMember(String id) {
    var userExpense = controller.getTotalOfMember(id);
    var member = controller.getMember(id);

    var diff = userExpense - controller.getTotal() / controller.members.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                member.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                formatCurrency.format(userExpense),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(${diff > 0 ? "+" : ""}${formatCurrency.format(diff)})',
              style: TextStyle(
                color: diff >= 0 ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDateSelection() {
    List<int> items = controller.tripNodes.asMap().entries.map((e) => e.key).toList();
    items.insert(0, -1);
    return DropdownButton<int>(
        value: controller.selectedDate,
        onChanged: (int? value) {
          if (value != null) {
            controller.onSelectDate(value);
          }
        },
        items: items.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: value == -1 ? const Text('Tất cả') : Text('Ngày ${value + 1}'),
          );
        }).toList());
  }

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

  buildTabItem(String label, int value, IconData icon) {
    bool isSelected = value == controller.selectedTab.value;
    return GestureDetector(
      onTap: () {
        controller.selectedTab.value = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),
        decoration: BoxDecoration(color: isSelected ? AppColors.primary : null, borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              size: 16,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTripPlanList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: controller.tripNodes.asMap().entries.map((e) => buildPlanItem(e.value, e.key)).toList(),
      ),
    );
  }

  Widget buildTripTotalExpense() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency.format(controller.getTotal()),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${formatCurrency.format(controller.eachMember())} / người',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Divider(
            height: 28,
            color: Colors.grey[400],
          ),
          Column(
            children: controller.members.map((m) => buildExpenseDetailForMember(m.uid)).toList(),
          )
        ],
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
      child: Text(
        'Ngày ${index + 1}',
        style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
      ),
    );
  }

  buildTab() {
    switch (controller.selectedTab.value) {
      case 0:
        return buildTripPlanList();
      case 1:
        return buildTripTotalExpense();
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
            backgroundColor: AppColors.background,
            appBar: AppBar(
              titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                controller.trip.value!.name,
              ),
              automaticallyImplyLeading: false,
              leading: const Icon(Icons.arrow_back),
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.background,
              actions: [
                PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 0) {
                        Get.toNamed(
                          '${AppRoutes.trips}/${controller.id}/settings',
                          arguments: {
                            'trip': controller.trip.value,
                          },
                        )!
                            .then((value) {
                          controller.getTripById();
                        });
                      }
                      if (value == 1) {
                        await controller.addNode();
                      }
                    },
                    itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 0,
                            child: Text('Cài đặt'),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text('Thêm ngày'),
                          ),
                        ])
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildTabItem('Lịch Trình', 0, Icons.train),
                    buildTabItem('Chi Phí', 1, Icons.payments),
                    buildTabItem('Thành viên', 2, Icons.people),
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                  child: buildTab(),
                  padding: const EdgeInsets.all(16),
                )))
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
