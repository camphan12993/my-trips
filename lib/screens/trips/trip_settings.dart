import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/models/app_user.dart';

class TripSettings extends GetView<TripSettingController> {
  const TripSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                      hintText: 'Input your name',
                      labelText: 'Name',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Row(
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
                        items: controller.users.map<DropdownMenuItem<String>>((AppUser value) {
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
            ),
            Obx(
              () => controller.members.isNotEmpty
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
                                      onPressed: () => controller.addMember(u.uid),
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
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: controller.updateTrip,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
