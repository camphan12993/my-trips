import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/core/app_utils.dart';
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
  int pickedTimes = 0;
  TimeOfDay? initTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.plan != null) {
      _nameController.text = widget.plan!.name;
      _noteController.text = widget.plan!.note ?? '';
    }
    initTimePicker();
  }

  void initTimePicker() {
    initTime = widget.plan != null ? AppUtils.getTimeOfDate(widget.plan!.time) : TimeOfDay.now();
    _timeController.text = initTime!.format(context);
    pickedTimes = initTime!.hour * 60 + initTime!.minute;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: const Text(
        'Địa điểm',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Tên địa điểm'),
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
                  decoration: InputDecoration(
                      hintText: 'Thời gian',
                      suffixIcon: Icon(
                        Icons.timer_outlined,
                        size: 20,
                        color: AppColors.primary,
                      )),
                  onTap: () async {
                    try {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: initTime!,
                        initialEntryMode: TimePickerEntryMode.input,
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        ),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          pickedTimes = pickedTime.minute + pickedTime.hour * 60;
                          _timeController.text = pickedTime.format(context);
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
                  decoration: const InputDecoration(hintText: 'Ghi chú'),
                ),
              ],
            )),
      ),
      actions: [
        widget.plan == null
            ? ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _tripDetailController.addPlanNode(
                        widget.nodeId,
                        AddPlanNodePayload(
                          name: _nameController.text,
                          time: pickedTimes,
                          note: _noteController.text,
                          nodeId: widget.nodeId,
                        ));
                    Get.back();
                  }
                },
                child: const Text('Thêm'),
              )
            : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _tripDetailController.updatePlanNode(
                        widget.nodeId,
                        widget.plan!.id,
                        AddPlanNodePayload(
                          name: _nameController.text,
                          time: pickedTimes,
                          note: _noteController.text,
                          nodeId: widget.nodeId,
                        ));
                    Get.back();
                  }
                },
                child: const Text('Lưu'),
              ),
      ],
    );
  }
}
