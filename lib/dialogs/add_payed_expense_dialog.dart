import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';

import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/models/trip_payed_expense.dart';

class AddPayedExpenseDialog extends StatefulWidget {
  final TripPayedExpense? expense;
  final String memberId;
  const AddPayedExpenseDialog({
    Key? key,
    this.expense,
    required this.memberId,
  }) : super(key: key);

  @override
  State<AddPayedExpenseDialog> createState() => _AddPayedExpenseDialogState();
}

class _AddPayedExpenseDialogState extends State<AddPayedExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final TripDetailController _tripDetailController = Get.find();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _moneyController.text = toCurrencyString(widget.expense!.value.toString(), thousandSeparator: ThousandSeparator.Period, mantissaLength: 0);
      _nameController.text = widget.expense!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Chi tiêu',
        style: TextStyle(color: AppColors.primary, fontSize: 16),
      ),
      contentPadding: const EdgeInsets.only(top: 20, bottom: 0, left: 24, right: 24),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Tên chi tiêu'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên chi tiêu';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _moneyController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(mantissaLength: 0, thousandSeparator: ThousandSeparator.Period),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập giá trị';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Giá trị', suffixText: 'đ'),
                ),
              ],
            )),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _tripDetailController.addPayedExpense({
                  'userId': widget.memberId,
                  'name': _nameController.text,
                  'value': int.parse((toNumericString(_moneyController.text))),
                });
                Get.back(result: true);
              }
            },
            child: const Text('Thêm'),
          ),
        )
      ],
    );
  }
}
