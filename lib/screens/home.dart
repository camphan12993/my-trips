import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/controllers/home_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/dialogs/add_trip_dialog.dart';
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
        onPressed: () => Get.dialog(const AddTripDialog()).then((value) {
          if (value == true) {
            controller.getTrips();
          }
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
                                      onTap: () {
                                        Get.toNamed(
                                          '${AppRoutes.trips}/${e.id}',
                                        );
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.09),
                                              blurRadius: 14,
                                              spreadRadius: -2,
                                              offset: Offset(2, -1),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          e.name,
                                                          style: TextStyle(
                                                            color: AppColors.primary,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text('${e.members.length} members')
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    DateFormat('dd-MM-yyyy').format(DateTime.parse(e.startDate)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
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
                                                    child: Container(
                                                      decoration: const BoxDecoration(color: Colors.red),
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
