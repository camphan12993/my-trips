import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/models/plan_node.dart';
import 'package:my_trips_app/models/trip_node.dart';
import 'package:my_trips_app/screens/trips/widgets/expense_item.dart';

import '../../../controllers/trips/trip_detail_controller.dart';
import '../../../dialogs/add_plan_node.dart';
import '../../../dialogs/add_spend_dialog.dart';
import '../../../widgets/app_icon_button.dart';
import '../../../widgets/data_placeholder.dart';

class TripDayPlan extends StatelessWidget {
  final TripDetailController _controller = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);

  TripDayPlan({super.key});
  buildListDay() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _controller.tripNodes
                  .asMap()
                  .entries
                  .map((e) => GestureDetector(
                        onTap: () {
                          _controller.selectedDay.value = e.key;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: _controller.selectedDay.value == e.key ? Colors.grey[200] : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Ngày',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _controller.currentDay.value == e.key
                                        ? AppColors.primary
                                        : _controller.selectedDay.value == e.key
                                            ? Colors.black
                                            : Colors.grey[500]),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${e.key + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: _controller.currentDay.value == e.key
                                        ? AppColors.primary
                                        : _controller.selectedDay.value == e.key
                                            ? Colors.black
                                            : Colors.grey[500]),
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTimeLine() {
    return _controller.currentNode.plans.isNotEmpty
        ? Column(
            children: _controller.currentNode.plans
                .asMap()
                .entries
                .map(
                  (e) => buildPlanNode(e.value, e.key == 2, e.key == _controller.currentNode.plans.length - 1),
                )
                .toList(),
          )
        : const DataPlaceholder(
            text: 'Chưa có địa điểm',
          );
  }

  Widget buildPlanNode(PlanNode plan, bool isCurrent, [bool isLast = false]) {
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
                  border: Border.all(color: isCurrent ? AppColors.primary : Colors.grey[400]!, width: 2),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Text(
                plan.time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
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
                    color: isCurrent ? AppColors.primary : Colors.grey[400]!,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 10),
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
                          border: Border(right: BorderSide(color: isCurrent ? AppColors.primary : Colors.grey[400]!, width: 4)),
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
              if (_controller.isEditPlace.value)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, top: 8),
                    child: GestureDetector(
                      onTap: () => Get.dialog(
                        AddPlanNodeDialog(
                          nodeId: _controller.currentNode.id,
                          plan: plan,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget buildExpense() {
    TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(6)),
        child: currentDay.expenses.isNotEmpty
            ? Column(
                children: [
                  ...currentDay.expenses
                      .map(
                        (ep) => ExpenseItem(
                          data: ep,
                          memberName: _controller.getMemberName(ep.userId),
                        ),
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
                          formatCurrency.format(_controller.getTotalInNode(currentDay.expenses)),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              )
            : const DataPlaceholder(
                text: 'Chưa có chi tiêu',
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          buildListDay(),
          const SizedBox(
            height: 24,
          ),
          Expanded(
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
                      if (!_controller.isEditPlace.value) ...[
                        AppIconButton(
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          onTap: () => _controller.isEditPlace.value = true,
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
                            AddPlanNodeDialog(nodeId: _controller.currentNode.id),
                          ),
                        )
                      ] else
                        AppIconButton(
                          Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                          onTap: () => _controller.isEditPlace.value = false,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildTimeLine(),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Chi tiêu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
                        ),
                      ),
                      AppIconButton(
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        onTap: () => Get.dialog(
                          AddSpendDialog(nodeId: _controller.currentNode.id),
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
                          AddSpendDialog(nodeId: _controller.currentNode.id),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildExpense()
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
