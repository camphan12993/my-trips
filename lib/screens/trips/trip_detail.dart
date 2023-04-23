import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/models/trip_node.dart';
import 'package:my_trips_app/screens/trips/components/trip_day_plan.dart';
import 'package:my_trips_app/screens/trips/components/trip_total_expense.dart';

import '../../core/app_utils.dart';
import 'components/trip_settings.dart';

class TripDetail extends GetView<TripDetailController> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN', name: 'VND', decimalDigits: 0);
  TripDetail({super.key});

  Widget buildPlanItem(TripNode node, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.09),
            offset: Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ngày ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 10,
                  spreadRadius: -4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    switch (controller.bottomTabIndex.value) {
      case 0:
        return TripDayPlan();
      case 1:
        return TripTotalExpense();
      case 2:
        return TripSettings();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (controller.trip.value != null) {
        return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                iconTheme: const IconThemeData(color: Colors.white),
                title: Column(
                  children: [
                    Text(
                      controller.trip.value!.name,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      AppUtils.getCountDownTime(
                        controller.trip.value!.startDate,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    )
                  ],
                ),
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back)),
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.primary,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.train), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.money),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '',
                ),
              ],
              currentIndex: controller.bottomTabIndex.value,
              onTap: (value) {
                controller.bottomTabIndex.value = value;
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 28, left: 24, right: 24),
                      child: buildBody()),
                ),
              ],
            ));
      }
      return const Scaffold(
        body: Center(
          child: Text('No Data'),
        ),
      );
    });
  }
}
