import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/core/app_utils.dart';
import 'package:my_trips_app/models/plan_node.dart';
import 'package:my_trips_app/models/trip_node.dart';
import 'package:my_trips_app/screens/trips/widgets/expense_item.dart';
import 'package:my_trips_app/widgets/app_slidable.dart';

import '../../../controllers/trips/trip_detail_controller.dart';
import '../../../dialogs/add_plan_node.dart';
import '../../../dialogs/add_spend_dialog.dart';
import '../../../widgets/app_icon_button.dart';
import '../../../widgets/data_placeholder.dart';

class TripDayPlan extends StatelessWidget {
  final TripDetailController _controller = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);

  TripDayPlan({super.key});

  Widget buildListDay() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 16, color: AppColors.primary),
                ),
                content: const Text('Bạn muốn thêm ngày mới?'),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      await _controller.addNode();
                      Get.back();
                    },
                    child: const Text('Thêm'),
                  ),
                ],
              ),
            );
          },
          child: DottedBorder(
              color: AppColors.primary,
              borderType: BorderType.RRect,
              radius: const Radius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Thêm ngày',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.add,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              )),
        ),
        if (_controller.tripNodes.isNotEmpty)
          ..._controller.tripNodes
              .asMap()
              .entries
              .map((e) => GestureDetector(
                    onTap: () {
                      _controller.selectedDay.value = e.key;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                          color: _controller.selectedDay.value == e.key ? AppColors.primary.withOpacity(0.1) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _controller.selectedDay.value == e.key ? AppColors.primary : Colors.transparent)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ngày',
                            style: TextStyle(
                              fontSize: 12,
                              color: _controller.currentDay.value == e.key || _controller.selectedDay.value == e.key ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${e.key + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: _controller.currentDay.value == e.key || _controller.selectedDay.value == e.key ? AppColors.primary : AppColors.textPrimary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList()
      ],
    );
  }

  Widget buildTimeLine(List<PlanNode> plans, BuildContext context) {
    return plans.isNotEmpty
        ? SlidableAutoCloseBehavior(
            child: Column(
              children: plans
                  .asMap()
                  .entries
                  .map(
                    (e) => buildPlanNode(e.value, context, e.key == plans.length - 1),
                  )
                  .toList(),
            ),
          )
        : const DataPlaceholder(
            text: 'Chưa có địa điểm',
          );
  }

  Widget buildPlanNode(PlanNode plan, BuildContext context, [bool isLast = false]) {
    bool hasVisited = false;
    if (_controller.trip.value!.hasEnd || _controller.currentDay.value > _controller.selectedDay.value) {
      hasVisited = true;
    } else if (_controller.currentDay.value == _controller.selectedDay.value) {
      TimeOfDay now = TimeOfDay.now();
      hasVisited = plan.time <= (now.hour * 60 + now.minute);
    }
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: hasVisited ? AppColors.primary : Colors.grey[400]!, width: 2),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Text(
                AppUtils.getTimeOfDate(plan.time).format(context),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: hasVisited ? AppColors.primary : AppColors.textPrimary,
                ),
              )
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 12,
                child: Center(
                  child: Container(
                    width: 1,
                    color: hasVisited ? AppColors.primary : Colors.grey[400]!,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 10),
                  child: AppSlidable(
                    onDelete: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text(
                            'Xoá địa điểm này?',
                            style: TextStyle(fontSize: 14),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];
                                await _controller.deletePlanNode(currentDay.id, plan.id);
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Xoá'),
                            )
                          ],
                        ),
                      );
                    },
                    onEdit: () {
                      TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];
                      Get.dialog(
                        AddPlanNodeDialog(
                          nodeId: currentDay.id,
                          plan: plan,
                        ),
                      );
                    },
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), spreadRadius: -4, blurRadius: 18, offset: Offset(0, -2)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(right: BorderSide(color: hasVisited ? AppColors.primary : Colors.grey[400]!, width: 4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                plan.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildExpense(BuildContext context) {
    TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];

    return SlidableAutoCloseBehavior(
      child: Column(
        children: [
          if (currentDay.expenses.isNotEmpty)
            ...currentDay.expenses
                .map(
                  (ep) => AppSlidable(
                    key: ValueKey(ep.id),
                    onDelete: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text(
                            'Xoá chi tiêu này?',
                            style: TextStyle(fontSize: 14),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];
                                await _controller.deleteExpend(currentDay.id, ep.id);
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Xoá'),
                            )
                          ],
                        ),
                      );
                    },
                    onEdit: () {
                      TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];
                      Get.dialog(
                        AddSpendDialog(
                          expense: ep,
                          nodeId: currentDay.id,
                        ),
                      );
                    },
                    child: ExpenseItem(
                      data: ep,
                      memberName: _controller.memberName(ep.userId),
                      formatCurrency: _controller.formatCurrency,
                    ),
                  ),
                )
                .toList()
          else
            const DataPlaceholder(
              text: 'Chưa có chi tiêu',
            ),
          if (currentDay.expenses.isNotEmpty) ...[
            const Divider(),
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
                    formatCurrency.format(_controller.getTotalInNode(currentDay.expenses)),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  buildTripDetailBody(BuildContext context) {
    TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Địa điểm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
                  ),
                ),
                AppIconButton(
                  Icon(
                    Icons.add,
                    color: AppColors.primary,
                  ),
                  onTap: () => Get.dialog(
                    AddPlanNodeDialog(nodeId: _controller.tripNodes[_controller.selectedDay.value].id),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            buildTimeLine(currentDay.plans, context),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Chi tiêu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                AppIconButton(
                  Icon(
                    Icons.add,
                    color: AppColors.primary,
                  ),
                  onTap: () => Get.dialog(
                    AddSpendDialog(nodeId: currentDay.id),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            buildExpense(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildListDay(),
          const SizedBox(
            height: 16,
          ),
          if (_controller.tripNodes.isNotEmpty) buildTripDetailBody(context) else const DataPlaceholder(text: 'Chưa có lịch trình'),
        ],
      );
    });
  }
}
