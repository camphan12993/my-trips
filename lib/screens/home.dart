import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/home_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.createTrip);
              },
              child: Text('Create new trip'),
            ),
            ElevatedButton(
              onPressed: controller.signout,
              child: Text('Sign out'),
            ),
          ],
        ),
      )),
    );
  }
}
