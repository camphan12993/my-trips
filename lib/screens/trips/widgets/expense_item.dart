import 'package:flutter/material.dart';
import 'package:my_trips_app/core/app_colors.dart';

import 'package:my_trips_app/core/app_utils.dart';
import 'package:my_trips_app/models/trip_expense.dart';

class ExpenseItem extends StatelessWidget {
  final TripExpense data;
  final String memberName;
  const ExpenseItem({
    Key? key,
    required this.data,
    required this.memberName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                memberName,
                style: TextStyle(color: AppColors.primary, fontSize: 12),
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
                AppUtils.formatCurrency.format(data.value),
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
    );
  }
}
