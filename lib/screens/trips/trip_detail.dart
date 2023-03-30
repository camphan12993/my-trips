import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/dialogs/add_plan_node.dart';
import 'package:my_trips_app/dialogs/add_spend_dialog.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/models/trip_expense.dart';
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
                style: const TextStyle(fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (controller.trip.value != null) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(controller.trip.value!.name),
            centerTitle: true,
            actions: [
              PopupMenuButton(
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
          body: RefreshIndicator(
            onRefresh: () => controller.getTripById(),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 16,
                      right: 16,
                      bottom: 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...controller.tripNodes
                            .asMap()
                            .entries
                            .map(
                              (e) => Container(
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                                padding: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Ngày ${e.key + 1}',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 32,
                                          child: PopupMenuButton(
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) {
                                                if (value == 1) {
                                                  Get.dialog(
                                                    AlertDialog(
                                                      title: const Text(
                                                        'Xoá ngày này?',
                                                        style: TextStyle(fontSize: 14),
                                                      ),
                                                      actionsAlignment: MainAxisAlignment.center,
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            await controller.deleteNode(e.value.id);
                                                            Get.back();
                                                            controller.getTripNodes();
                                                          },
                                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                          child: const Text('Xoá'),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        value: 1,
                                                        child: Text(
                                                          'Xoá',
                                                          style: TextStyle(color: Colors.red),
                                                        ))
                                                  ]),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Lịch trình',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            AppIconButton(
                                              const Icon(
                                                Icons.add,
                                                size: 14,
                                                color: Colors.blue,
                                              ),
                                              onTap: () => Get.dialog(
                                                AddPlanNodeDialog(nodeId: e.value.id),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        e.value.plans.isNotEmpty
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: e.value.plans
                                                    .map((p) => AppExpansionPanel(
                                                        onEdit: () => Get.dialog(AddPlanNodeDialog(
                                                              nodeId: e.value.id,
                                                              plan: p,
                                                            )),
                                                        header: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              '${p.time}:',
                                                              style: const TextStyle(
                                                                color: Colors.blue,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              p.name,
                                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                        body: Container(
                                                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                                                          padding: const EdgeInsets.all(12),
                                                          margin: const EdgeInsets.only(top: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const Text(
                                                                'Ghi chú:',
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              p.note != null && p.note!.isNotEmpty
                                                                  ? Text(
                                                                      p.note ?? '',
                                                                    )
                                                                  : const DataPlaceholder(text: 'Chưa có ghi chú'),
                                                            ],
                                                          ),
                                                        )))
                                                    .toList(),
                                              )
                                            : const DataPlaceholder(
                                                text: 'Chưa có địa điểm',
                                              ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Chi tiêu',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            AppIconButton(
                                              const Icon(
                                                Icons.add,
                                                size: 14,
                                                color: Colors.blue,
                                              ),
                                              onTap: () => Get.dialog(AddSpendDialog(
                                                nodeId: e.value.id,
                                              )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                                            child: e.value.expenses.isNotEmpty
                                                ? Column(
                                                    children: [
                                                      ...e.value.expenses
                                                          .map(
                                                            (ep) => buildExpenseItem(ep, e.value.id),
                                                          )
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
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Chi phí khác',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            AppIconButton(
                              const Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.blue,
                              ),
                              onTap: () => Get.dialog(const AddSpendDialog()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (controller.trip.value!.otherExpense.isNotEmpty)
                          ...controller.trip.value!.otherExpense.map((e) => buildExpenseItem(e)).toList()
                        else
                          const DataPlaceholder(
                            text: 'Chưa có chi tiêu',
                          )
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
                            Text(
                              '${controller.eachMember()}',
                              textAlign: TextAlign.right,
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
