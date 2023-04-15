import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

import '../../../models/app_user.dart';

class TripSettings extends StatelessWidget {
  final TripDetailController _controller = Get.find();

  TripSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Tên',
                  labelText: 'Tên chuyến đi',
                ),
              ),
              TextFormField(
                controller: _controller.startDateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Chọn ngày';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  _controller.formSelectedDate.value = await showDatePicker(
                    context: context,
                    initialDate: _controller.formSelectedDate.value ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2060),
                  );
                  if (_controller.formSelectedDate.value != null) {
                    _controller.startDateController.text = DateFormat('dd-MM-yyyy').format(_controller.formSelectedDate.value!);
                  }
                },
                decoration: const InputDecoration(hintText: 'Ngày khởi hành', labelText: 'Ngày khởi hành', suffixIcon: Icon(Icons.calendar_month)),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 60,
          child: DropdownButton<String>(
            isExpanded: true,
            value: _controller.selectedUser.value,
            onChanged: (String? value) {
              _controller.selectedUser.value = value;
              _controller.addMember(_controller.selectedUser.value!);
            },
            hint: const Text('Thêm thành viên'),
            items: _controller.listUsers.map<DropdownMenuItem<String>>((AppUser value) {
              return DropdownMenuItem<String>(
                value: value.uid,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
        _controller.members.isNotEmpty
            ? Column(
                children: _controller.members
                    .map((u) => Row(
                          children: [
                            Expanded(
                                child: Text(
                              u.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              color: Colors.red,
                              onPressed: () => _controller.deleteMember(u.uid),
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ))
                    .toList(),
              )
            : const Padding(
                padding: EdgeInsets.all(18.0),
                child: DataPlaceholder(text: 'Chưa có thành viên nào'),
              ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: _controller.updateTrip,
          child: const Text('Lưu'),
        )
      ],
    );
  }
}
