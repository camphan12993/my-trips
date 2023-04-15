import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/trips/trip_detail_controller.dart';

class TripTotalExpense extends StatelessWidget {
  final TripDetailController _controller = Get.find();
  TripTotalExpense({super.key});
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);
  Widget buildExpenseDetailForMember(String id) {
    var userExpense = _controller.getTotalOfMember(id);
    var member = _controller.getMember(id);

    var diff = userExpense - _controller.getTotal() / _controller.members.length;
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
                const Text(
                  'Tổng',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
            )
          ],
        ),
      ],
    );
    ;
  }
}
