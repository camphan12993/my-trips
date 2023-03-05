import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_routes.dart';

class TripDetail extends GetView<TripDetailController> {
  const TripDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.trip.value != null
          ? Scaffold(
              appBar: AppBar(
                title: Text(controller.trip.value!.name),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed('${AppRoutes.trips}/${controller.id}/settings')!.then((value) {
                        controller.getTripById();
                      });
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            )
          : const Scaffold(
              body: Center(
                child: Text('No Data'),
              ),
            ),
    );
  }
}
