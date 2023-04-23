import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/dialogs/add_payed_expense_dialog.dart';
import 'package:my_trips_app/models/trip_member.dart';
import 'package:my_trips_app/models/trip_payed_expense.dart';
import 'package:my_trips_app/screens/trips/widgets/expense_item.dart';
import 'package:my_trips_app/widgets/app_card_wrapper.dart';
import 'package:my_trips_app/widgets/app_slidable.dart';

import '../../../controllers/trips/trip_detail_controller.dart';
import '../../../dialogs/add_spend_dialog.dart';
import '../../../widgets/app_icon_button.dart';
import '../../../widgets/data_placeholder.dart';

class TripTotalExpense extends StatelessWidget {
  final TripDetailController _controller = Get.find();
  TripTotalExpense({super.key});
  Widget buildExpenseDetailForMember(TripMember member) {
    var userExpense = _controller.getTotalOfMember(member.id);
    List<TripPayedExpense> items = _controller.trip.value!.payedExpenses.where((p) => p.userId == member.id).toList();
    int total = 0;
    for (var i in items) {
      total = total + i.value;
    }

    var diff = userExpense - _controller.getTotal() / _controller.members.length + total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                member.name,
                style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
              Text(
                userExpense > 0 ? _controller.formatCurrency.format(userExpense) : '-',
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (total > 0)
                Text.rich(
                  TextSpan(
                    text: '(Đã góp ',
                    style: const TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: _controller.formatCurrency.format(total),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const TextSpan(
                        text: ')',
                      ),
                    ],
                  ),
                ),
              if (total == 0)
                const Text(
                  '(Chưa góp)',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              Text(
                '(${diff >= 0 ? "Dư" : "Thiếu"} ${_controller.formatCurrency.format(diff.abs())})',
                style: TextStyle(
                  color: diff >= 0 ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.primary,
      ),
    );
  }

  Widget buildPayedItem(TripMember member) {
    List<TripPayedExpense> items = _controller.trip.value!.payedExpenses.where((p) => p.userId == member.id).toList();
    int total = 0;
    for (var i in items) {
      total = total + i.value;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppIconButton(
              Icon(
                Icons.add,
                color: AppColors.primary,
              ),
              onTap: () => Get.dialog(AddPayedExpenseDialog(
                memberId: member.id,
              )).then((value) {
                if (value) {}
              }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        AppCardWrapper(
          child: Column(
            children: [
              if (items.isNotEmpty) ...[
                ...items.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.name),
                          Text(
                            _controller.formatCurrency.format(e.value),
                          )
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _controller.formatCurrency.format(total),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ] else
                const DataPlaceholder(
                  text: 'Chưa góp',
                )
            ],
          ),
        )
      ],
    );
  }

  Widget buildExpenseByDay() {
    return AppCardWrapper(
      child: _controller.tripNodes.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var node = _controller.tripNodes[index];
                var total = _controller.getTotalInNode(node.expenses);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ngày ${index + 1}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      total > 0
                          ? _controller.formatCurrency.format(
                              total,
                            )
                          : '-',
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: _controller.tripNodes.length)
          : const DataPlaceholder(text: 'Chưa có lịch trình'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSectionTitle('Tổng'),
              Text(
                _controller.formatCurrency.format(_controller.getTotal()),
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
              '${_controller.formatCurrency.format(_controller.eachMember())} / người',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          AppCardWrapper(
            child: Column(
              children: _controller.members.map((m) => buildExpenseDetailForMember(m)).toList(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSectionTitle('Chi phí khác'),
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
          _controller.trip.value!.otherExpense.isNotEmpty
              ? Column(
                  children: _controller.trip.value!.otherExpense
                      .map(
                        (e) => AppSlidable(
                          key: ValueKey(e.id),
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
                                      await _controller.deleteTripExpense(e.id);
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
                            Get.dialog(
                              AddSpendDialog(
                                expense: e,
                              ),
                            );
                          },
                          child: ExpenseItem(
                            data: e,
                            memberName: _controller.memberName(e.userId),
                            formatCurrency: _controller.formatCurrency,
                          ),
                        ),
                      )
                      .toList(),
                )
              : const DataPlaceholder(
                  text: 'Chưa có chi tiêu',
                ),
          const SizedBox(
            height: 16,
          ),
          buildSectionTitle('Theo Ngày'),
          const SizedBox(
            height: 8,
          ),
          buildExpenseByDay(),
          const SizedBox(
            height: 16,
          ),
          buildSectionTitle('Đã góp'),
          const SizedBox(
            height: 8,
          ),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => buildPayedItem(_controller.members[index]),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: _controller.members.length),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
    ;
  }
}
