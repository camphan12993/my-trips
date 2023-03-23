import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:my_trips_app/components/user_avatar.dart';
import 'package:my_trips_app/dialogs/add_spend_dialog.dart';
import 'package:my_trips_app/models/trip_expense.dart';
import 'package:my_trips_app/models/trip_node.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

class TripNodeElement extends StatelessWidget {
  final TripNode data;
  final int index;
  TripNodeElement({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);

  double getTotalInNode(List<TripExpense> expenses) {
    double result = 0;
    for (var element in expenses) {
      result += element.value;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(data.id),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày $index',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data.date,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
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
                      const Text('Lịch trình'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Chi tiêu'),
                      ElevatedButton(
                        onPressed: () => Get.dialog(AddSpendDialog(
                          nodeId: data.id,
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
                      child: data.expenses.isNotEmpty
                          ? Column(
                              children: [
                                ...data.expenses
                                    .map((ep) => GestureDetector(
                                          onLongPress: () {
                                            Get.dialog(AddSpendDialog(
                                              nodeId: data.id,
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
                                        formatCurrency.format(getTotalInNode(data.expenses)),
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
    );
  }
}
