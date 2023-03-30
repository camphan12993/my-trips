import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/models/add_plan_node_payload.dart';
import 'package:my_trips_app/models/plan_node.dart';

class AddPlanNodeDialog extends StatefulWidget {
  final String nodeId;
  final PlanNode? plan;
  const AddPlanNodeDialog({
    Key? key,
    required this.nodeId,
    this.plan,
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
    if (widget.plan != null) {
      _nameController.text = widget.plan!.name;
      _noteController.text = widget.plan!.note ?? '';
      _timeController.text = widget.plan!.time;
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
                  try {
                    TimeOfDay? initTime;
                    if (_timeController.text.isNotEmpty) {
                      initTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeController.text));
                    }
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: initTime ?? TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input,
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      ),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _timeController.text = '${pickedTime.hour < 12 ? '0' : ''}${pickedTime.hour}:${pickedTime.minute}';
                      });
                    }
                  } catch (e) {
                    final snackBar = SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        widget.plan == null
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
                        await _tripDetailController.updatePlanNode(
                            widget.nodeId,
                            widget.plan!.id,
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
                      await _tripDetailController.deletePlanNode(
                        widget.nodeId,
                        widget.plan!.id,
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
