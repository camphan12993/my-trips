import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/models/trip_expense.dart';

class ExpenseItem extends StatelessWidget {
  final TripExpense data;
  final String memberName;
  final NumberFormat formatCurrency;
  const ExpenseItem({
    Key? key,
    required this.data,
    required this.memberName,
    required this.formatCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                memberName,
                style: TextStyle(color: AppColors.primary, fontSize: 14),
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
                style: const TextStyle(fontSize: 14),
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
