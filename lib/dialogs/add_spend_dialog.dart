import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/models/trip_expense.dart';

import '../models/app_user.dart';

class AddSpendDialog extends StatefulWidget {
  final String nodeId;
  final TripExpense? expense;
  const AddSpendDialog({
    Key? key,
    required this.nodeId,
    this.expense,
  }) : super(key: key);

  @override
  State<AddSpendDialog> createState() => _AddSpendDialogState();
}

class _AddSpendDialogState extends State<AddSpendDialog> {
  final _formKey = GlobalKey<FormState>();
  final TripDetailController _tripDetailController = Get.find();
  String? _selectedMemberId;
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _moneyController.text = widget.expense!.value.toString();
      _desController.text = widget.expense!.name;
      _selectedMemberId = widget.expense!.userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chi tiêu'),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _desController,
                decoration: const InputDecoration(labelText: 'Mặt hàng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng thêm mặt hàng';
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá trị';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Giá trị', suffixText: 'VND'),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedMemberId,
                  onChanged: (String? value) {
                    _selectedMemberId = value;
                    setState(() {});
                  },
                  hint: const Text('Người chi'),
                  items: _tripDetailController.members.map<DropdownMenuItem<String>>((AppUser value) {
                    return DropdownMenuItem<String>(
                      value: value.uid,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              )
            ],
          )),
      actions: [
        widget.expense == null
            ? Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _selectedMemberId != null) {
                      await _tripDetailController.addExpend(
                        nodeId: widget.nodeId,
                        userId: _selectedMemberId!,
                        name: _desController.text,
                        value: double.parse(_moneyController.text),
                      );
                      Get.back();
                    }
                  },
                  child: const Text('Thêm'),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _selectedMemberId != null) {
                        await _tripDetailController.updateExpend(
                          nodeId: widget.nodeId,
                          expenseId: widget.expense!.id,
                          userId: _selectedMemberId!,
                          name: _desController.text,
                          value: double.parse(_moneyController.text),
                        );
                        Get.back();
                      }
                    },
                    child: const Text('Lưu'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      await _tripDetailController.deleteExpend(
                        nodeId: widget.nodeId,
                        expenseId: widget.expense!.id,
                      );
                      Get.back();
                    },
                    child: const Text('Xoá'),
                  )
                ],
              ),
      ],
    );
  }
}
