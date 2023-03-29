import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/models/expense_payload.dart';
import 'package:my_trips_app/models/trip_expense.dart';
import 'package:my_trips_app/models/trip_expense_payload.dart';

import '../models/app_user.dart';

class AddSpendDialog extends StatefulWidget {
  final String? nodeId;
  final TripExpense? expense;
  const AddSpendDialog({
    super.key,
    this.nodeId,
    this.expense,
  });

  @override
  State<AddSpendDialog> createState() => _AddSpendDialogState();
}

class _AddSpendDialogState extends State<AddSpendDialog> {
  final _formKey = GlobalKey<FormState>();
  final TripDetailController _tripDetailController = Get.find();
  String? _selectedMemberId;
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  // final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _moneyController.text = toCurrencyString(widget.expense!.value.toString(), thousandSeparator: ThousandSeparator.Period, mantissaLength: 0);
      _desController.text = widget.expense!.name;
      _selectedMemberId = widget.expense!.userId;
      _noteController.text = widget.expense!.note;
      // _timeController.text = widget.expense!.time;
    }
    // if (_timeController.text.isEmpty) {
    //   _timeController.text = DateFormat('HH:mm').format(DateTime.now());
    // }
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
                decoration: const InputDecoration(labelText: 'Giá trị', suffixText: 'đ'),
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
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              // TextFormField(
              //   controller: _timeController,
              //   readOnly: true,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Vui lòng chọn thời gian';
              //     }
              //     return null;
              //   },
              //   decoration: const InputDecoration(labelText: 'Thời gian', suffixIcon: Icon(Icons.timer_outlined)),
              //   onTap: () async {
              //     TimeOfDay? initTime;
              //     if (_timeController.text.isNotEmpty) {
              //       initTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeController.text));
              //     }
              //     TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initTime ?? TimeOfDay.now());
              //     if (pickedTime != null) {
              //       DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
              //       String formattedTime = DateFormat('HH:mm').format(parsedTime);
              //       setState(() {
              //         _timeController.text = formattedTime;
              //       });
              //     }
              //   },
              // )
            ],
          )),
      actions: [
        widget.expense == null
            ? Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _selectedMemberId != null) {
                      if (widget.nodeId != null) {
                        await _tripDetailController.addExpend(
                          ExpensePayload(
                            nodeId: widget.nodeId!,
                            userId: _selectedMemberId!,
                            value: int.parse((toNumericString(_moneyController.text))),
                            name: _desController.text,
                            note: _noteController.text,
                          ),
                        );
                      } else {
                        await _tripDetailController.addTripExpense(TripExpensePayload(
                          userId: _selectedMemberId!,
                          value: int.parse((toNumericString(_moneyController.text))),
                          name: _desController.text,
                          note: _noteController.text,
                        ));
                      }

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
                        if (widget.nodeId != null) {
                          await _tripDetailController.updateExpend(
                            widget.expense!.id,
                            ExpensePayload(
                              nodeId: widget.nodeId!,
                              userId: _selectedMemberId!,
                              value: int.parse((toNumericString(_moneyController.text))),
                              name: _desController.text,
                              note: _noteController.text,
                            ),
                          );
                        } else {
                          await _tripDetailController.updateTripExpense(
                              widget.expense!.id,
                              TripExpensePayload(
                                userId: _selectedMemberId!,
                                value: int.parse((toNumericString(_moneyController.text))),
                                name: _desController.text,
                                note: _noteController.text,
                              ));
                        }

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
                      if (widget.nodeId != null) {
                        await _tripDetailController.deleteExpend(
                          nodeId: widget.nodeId!,
                          expenseId: widget.expense!.id,
                        );
                      } else {
                        await _tripDetailController.deleteTripExpense(
                          widget.expense!.id,
                        );
                      }
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
