import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/home_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách chuyến đi'),
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
          () => controller.trips.isNotEmpty
              ? Column(
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
                )
              : const Center(
                  child: DataPlaceholder(text: 'Chưa có hành trình'),
                ),
        ),
      )),
    );
  }
}
