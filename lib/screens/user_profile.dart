import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';

class UserProfile extends GetView<UserProfileController> {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        actions: [
          IconButton(
            onPressed: controller.signout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFormField(
              //   initialValue: controller.user.email,
              //   readOnly: true,
              //   style: TextStyle(color: Colors.grey[500]),
              //   decoration: const InputDecoration(
              //     labelText: 'Email',
              //     enabled: false,
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nick name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: controller.updateUser,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
