import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:my_trips_app/controllers/index.dart';

import '../models/app_user.dart';

class AddSpendDialog extends StatefulWidget {
  final String nodeId;
  const AddSpendDialog({
    Key? key,
    required this.nodeId,
  }) : super(key: key);

  @override
  State<AddSpendDialog> createState() => _AddSpendDialogState();
}

class _AddSpendDialogState extends State<AddSpendDialog> {
  final _formKey = GlobalKey<FormState>();
  final TripDetailController _tripDetailController = Get.find();
  String? _selectedMemberId;
  final TextEditingController _moneyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add expend'),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _moneyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Value', suffixText: 'vnd'),
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
                  hint: const Text('Select member'),
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
        Center(
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _tripDetailController.addExpend(
                  nodeId: widget.nodeId,
                  userId: _selectedMemberId!,
                  value: double.parse(_moneyController.text),
                );
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ),
      ],
    );
  }
}
