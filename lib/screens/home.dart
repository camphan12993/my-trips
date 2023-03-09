import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/home_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.userProfile),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.createTrip)!.then((value) {
          controller.getTrips();
        }),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => Column(
            children: controller.trips
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Get.toNamed(
                              '${AppRoutes.trips}/${e.id}',
                            );
                          },
                          title: Text(
                            e.name,
                          ),
                          subtitle: Text('${e.memberIds.length} members'),
                          leading: const Icon(
                            Icons.people,
                            size: 30,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      )),
    );
  }
}
