import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

import '../../models/app_user.dart';

class CreateTrip extends GetView<CreateTripController> {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.trip != null ? 'Thông tin chuyến đi' : 'Tạo chuyến đi'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.nameController,
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
                      controller: controller.startDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chọn ngày';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () async {
                        controller.selectedDate.value = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2060),
                        );
                        if (controller.selectedDate.value != null) {
                          controller.startDateController.text = DateFormat('dd-MM-yyyy').format(controller.selectedDate.value!);
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
                  value: controller.selectedUser.value,
                  onChanged: (String? value) {
                    controller.selectedUser.value = value;
                    controller.addMember(controller.selectedUser.value!);
                  },
                  hint: const Text('Thêm thành viên'),
                  items: controller.listUsers.map<DropdownMenuItem<String>>((AppUser value) {
                    return DropdownMenuItem<String>(
                      value: value.uid,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
              controller.members.isNotEmpty
                  ? Column(
                      children: controller.members
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
                                    onPressed: () => controller.deleteMember(u.uid),
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
              controller.trip != null
                  ? ElevatedButton(
                      onPressed: controller.updateTrip,
                      child: const Text('Lưu'),
                    )
                  : ElevatedButton(
                      onPressed: controller.create,
                      child: const Text('Tạo'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
