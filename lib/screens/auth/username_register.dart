import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';

import '../../core/app_routes.dart';

class UsernameRegister extends GetView<UsernameRegisterController> {
  const UsernameRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.airplane_ticket_outlined,
                    size: 32,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "My Trips",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: controller.usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng tên tài khoản';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tên tài khoản',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: controller.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên hiển thị';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tên hiển thị',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: controller.register,
                child: const Text('Tạo tài khoản'),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Get.offNamed(AppRoutes.usernameLogin);
                  },
                  child: const Text('Đăng nhập?'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
