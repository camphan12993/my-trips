import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/controllers/home_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/core/app_utils.dart';
import 'package:my_trips_app/dialogs/add_trip_dialog.dart';
import 'package:my_trips_app/widgets/app_slidable.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

import '../core/app_colors.dart';
import '../models/trip.dart';

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
            'Hành Trình',
            style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w500),
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
                        child: SlidableAutoCloseBehavior(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller.trips.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 8,
                              );
                            },
                            itemBuilder: (context, index) {
                              return buildTripItem(controller.trips[index]);
                            },
                          ),
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

  Widget buildTripItem(Trip item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '${AppRoutes.trips}/${item.id}',
        );
      },
      child: AppSlidable(
        key: ValueKey(item.id),
        onDelete: () {
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
                    await controller.deleteTrip(item.id);
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
        child: DecoratedBox(
          decoration: const BoxDecoration(
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
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text('${item.members.length} thành viên')
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(item.startDate)),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        AppUtils.getCountDownTime(
                          item.startDate,
                        ),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
