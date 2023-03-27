import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/components/user_avatar.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/dialogs/add_plan_node.dart';
import 'package:my_trips_app/dialogs/add_spend_dialog.dart';
import 'package:intl/intl.dart';

import '../../widgets/data_placeholder.dart';

class TripDetail extends GetView<TripDetailController> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);
  TripDetail({super.key});

  Widget buildExpenseDetailForMember(String id) {
    var userExpense = controller.getTotalOfMember(id);
    var diff = userExpense - controller.getTotal() / controller.members.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserAvatar(uid: id),
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (controller.trip.value != null) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.trip.value!.name),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(
                    '${AppRoutes.trips}/${controller.id}/settings',
                    arguments: {
                      'trip': controller.trip.value,
                    },
                  )!
                      .then((value) {
                    controller.getTripById();
                  });
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    right: 12,
                    bottom: 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...controller.tripNodes
                          .asMap()
                          .entries
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ngày ${e.key + 1}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Lịch trình',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Get.dialog(AddPlanNodeDialog(nodeId: e.value.id)),
                                                style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  padding: const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          e.value.plans.isNotEmpty
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: e.value.plans
                                                      .map((e) => Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const Padding(
                                                                padding: EdgeInsets.only(top: 4.0),
                                                                child: Badge(
                                                                  smallSize: 8,
                                                                  backgroundColor: Colors.blue,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '${e.time}:',
                                                                    style: const TextStyle(fontWeight: FontWeight.w300),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    e.name,
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ))
                                                      .toList(),
                                                )
                                              : const DataPlaceholder(
                                                  text: 'Chưa có địa điểm',
                                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Chi tiêu',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Get.dialog(AddSpendDialog(
                                                  nodeId: e.value.id,
                                                )),
                                                style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  padding: const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(color: Colors.grey[100]),
                                              child: e.value.expenses.isNotEmpty
                                                  ? Column(
                                                      children: [
                                                        ...e.value.expenses
                                                            .map((ep) => GestureDetector(
                                                                  onLongPress: () {
                                                                    Get.dialog(AddSpendDialog(
                                                                      nodeId: e.value.id,
                                                                      expense: ep,
                                                                    ));
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
                                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        UserAvatar(uid: ep.userId),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Expanded(
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                ep.time,
                                                                                style: const TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontStyle: FontStyle.italic,
                                                                                  fontWeight: FontWeight.w300,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 6,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    ep.name,
                                                                                  ),
                                                                                  Text(
                                                                                    formatCurrency.format(ep.value),
                                                                                    style: const TextStyle(fontSize: 12),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              const Text(
                                                                'Tổng',
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                formatCurrency.format(controller.getTotalInNode(e.value.expenses)),
                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const DataPlaceholder(
                                                      text: 'Chưa có chi tiêu',
                                                    ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      ElevatedButton(
                          onPressed: () async {
                            await controller.addNode();
                            // Get.dialog(
                            //   AlertDialog(
                            //     title: const Text(
                            //       'New',
                            //       textAlign: TextAlign.center,
                            //     ),
                            //     content: Form(
                            //         key: controller.formKey,
                            //         child: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             TextFormField(
                            //               controller: controller.nameController,
                            //               decoration: const InputDecoration(labelText: 'Name'),
                            //             )
                            //           ],
                            //         )),
                            //     actions: [
                            //       Center(
                            //         child: ElevatedButton(
                            //           onPressed: () async {
                            //             await controller.addNode();
                            //             Get.back();
                            //           },
                            //           child: const Text('Add'),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                          child: const Icon(Icons.add)),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Chi phí khác',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                      // ...controller.trip.value!.otherExpense.map((e) => null)
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 6)], color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            controller.isShowDetail.value = !controller.isShowDetail.value;
                          },
                          child: const Icon(Icons.more_horiz),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
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
                          ),
                          Obx(
                            () => controller.isShowDetail.value
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                                    child: Column(
                                      children: controller.members.map((m) => buildExpenseDetailForMember(m.uid)).toList(),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
      return const Scaffold(
        body: Center(
          child: Text('No Data'),
        ),
      );
    });
  }
}
