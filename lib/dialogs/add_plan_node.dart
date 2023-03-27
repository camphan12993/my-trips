import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/models/add_plan_node_payload.dart';
import 'package:my_trips_app/models/plan_node.dart';

class AddPlanNodeDialog extends StatefulWidget {
  final String nodeId;
  final PlanNode? expense;
  const AddPlanNodeDialog({
    Key? key,
    required this.nodeId,
    this.expense,
  }) : super(key: key);

  @override
  State<AddPlanNodeDialog> createState() => _AddPlanNodeDialogState();
}

class _AddPlanNodeDialogState extends State<AddPlanNodeDialog> {
  final _formKey = GlobalKey<FormState>();
  final TripDetailController _tripDetailController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _noteController.text = widget.expense!.name;
      _timeController.text = widget.expense!.time;
    }
    if (_timeController.text.isEmpty) {
      _timeController.text = DateFormat('HH:mm').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Địa điểm'),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên địa điểm'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui nhập địa điểm';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn thời gian';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Thời gian', suffixIcon: Icon(Icons.timer_outlined)),
                onTap: () async {
                  TimeOfDay? initTime;
                  if (_timeController.text.isNotEmpty) {
                    initTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeController.text));
                  }
                  TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initTime ?? TimeOfDay.now());
                  if (pickedTime != null) {
                    DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                    String formattedTime = DateFormat('HH:mm').format(parsedTime);
                    setState(() {
                      _timeController.text = formattedTime;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
            ],
          )),
      actions: [
        widget.expense == null
            ? Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _tripDetailController.addPlanNode(
                          widget.nodeId,
                          AddPlanNodePayload(
                            name: _nameController.text,
                            time: _timeController.text,
                            note: _noteController.text,
                            nodeId: widget.nodeId,
                          ));
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
                      if (_formKey.currentState!.validate()) {
                        await _tripDetailController.addPlanNode(
                            widget.nodeId,
                            AddPlanNodePayload(
                              name: _nameController.text,
                              time: _timeController.text,
                              note: _noteController.text,
                              nodeId: widget.nodeId,
                            ));
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
