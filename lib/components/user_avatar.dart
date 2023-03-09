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
    return Column(
      children: [
        // const CircleAvatar(
        //   child: Icon(Icons.person),
        // ),
        Text(user?.name ?? '')
      ],
    );
  }
}
