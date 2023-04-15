import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/screens/trips/widgets/expense_item.dart';

import '../../../controllers/trips/trip_detail_controller.dart';
import '../../../dialogs/add_spend_dialog.dart';
import '../../../widgets/app_icon_button.dart';
import '../../../widgets/data_placeholder.dart';

class TripTotalExpense extends StatelessWidget {
  final TripDetailController _controller = Get.find();
  TripTotalExpense({super.key});
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);
  Widget buildExpenseDetailForMember(String id) {
    var userExpense = _controller.getTotalOfMember(id);

    var diff = userExpense - _controller.getTotal() / _controller.members.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _controller.getMemberName(id),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  formatCurrency.format(_controller.getTotal()),
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
                '${formatCurrency.format(_controller.eachMember())} / người',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
              child: Column(
                children: _controller.members.map((m) => buildExpenseDetailForMember(m.uid)).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chi phí khác',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                AppIconButton(
                  Icon(
                    Icons.add,
                    color: AppColors.primary,
                  ),
                  onTap: () => Get.dialog(const AddSpendDialog()),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if (_controller.trip.value!.otherExpense.isNotEmpty)
              ..._controller.trip.value!.otherExpense
                  .map(
                    (e) => ExpenseItem(
                      data: e,
                      memberName: _controller.getMemberName(e.userId),
                    ),
                  )
                  .toList()
            else
              const DataPlaceholder(
                text: 'Chưa có chi tiêu',
              )
          ],
        ),
      ],
    );
    ;
  }
}
