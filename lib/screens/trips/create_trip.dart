import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:intl/intl.dart';

import '../../models/app_user.dart';

class CreateTrip extends GetView<CreateTripController> {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.trip != null ? 'Trip Settings' : 'Create Trip'),
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
                          return 'Name is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Input trip name',
                        labelText: 'Name',
                      ),
                    ),
                    TextFormField(
                      controller: controller.startDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select start date';
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
                      decoration: const InputDecoration(hintText: 'Select start date', labelText: 'Start Date', suffixIcon: Icon(Icons.calendar_month)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedUser.value,
                        onChanged: (String? value) {
                          controller.selectedUser.value = value;
                        },
                        hint: const Text('Select member'),
                        items: controller.listUsers.map<DropdownMenuItem<String>>((AppUser value) {
                          return DropdownMenuItem<String>(
                            value: value.uid,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: controller.selectedUser.value != null ? () => controller.addMember(controller.selectedUser.value!) : null,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                    ),
                  )
                ],
              ),
              controller.members.isNotEmpty
                  ? Column(
                      children: controller.members
                          .map((u) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Text(u.name)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      color: Colors.red,
                                      onPressed: () => controller.deleteMember(u.uid),
                                      icon: const Icon(Icons.delete),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Please add more member',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              controller.trip != null
                  ? ElevatedButton(
                      onPressed: controller.updateTrip,
                      child: const Text('Save'),
                    )
                  : ElevatedButton(
                      onPressed: controller.create,
                      child: const Text('Create'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
