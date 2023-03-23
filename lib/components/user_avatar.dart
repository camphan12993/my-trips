import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_trips_app/controllers/auth/auth_controller.dart';

class UserAvatar extends StatelessWidget {
  final AuthController _authController = Get.find();
  final String uid;
  UserAvatar({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = _authController.getUserById(uid);
    String? name;
    if (user != null) {
      name = user.name[0];
    }
    return Container(
      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      padding: const EdgeInsets.all(14),
      child: name != null
          ? Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 24, color: Colors.white, height: 1),
                ),
              ),
            )
          : const Icon(Icons.person),
    );
  }
}
