import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/home_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

import '../core/app_colors.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(
            'Chuyến đi',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w500),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.userProfile),
              icon: Icon(
                Icons.person,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(AppRoutes.createTrip)!.then((value) {
          controller.getTrips();
        }),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => controller.trips.isNotEmpty
              ? Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.getTrips();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.trips
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: GestureDetector(
                                      onLongPress: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text(
                                              'Xoá chuyến đi này?',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            actionsAlignment: MainAxisAlignment.center,
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await controller.deleteTrip(e.id);
                                                  Get.back();
                                                  controller.getTrips();
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                child: const Text('Xoá'),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: ListTile(
                                          onTap: () {
                                            Get.toNamed(
                                              '${AppRoutes.trips}/${e.id}',
                                            );
                                          },
                                          trailing: Text(e.startDate),
                                          title: Text(
                                            e.name,
                                          ),
                                          subtitle: Text('${e.memberIds.length} members'),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: DataPlaceholder(text: 'Chưa có hành trình'),
                ),
        ),
      )),
    );
  }
}
