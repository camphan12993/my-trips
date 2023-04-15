import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/models/plan_node.dart';
import 'package:my_trips_app/models/trip_node.dart';

import '../../../controllers/trips/trip_detail_controller.dart';

class TripDayPlan extends StatelessWidget {
  final TripDetailController _controller = Get.find();

  TripDayPlan({super.key});
  buildListDay() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _controller.tripNodes
                  .asMap()
                  .entries
                  .map((e) => GestureDetector(
                        onTap: () {
                          _controller.selectedDay.value = e.key;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: _controller.selectedDay.value == e.key ? Colors.grey[200] : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Ngày',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _controller.currentDay.value == e.key
                                        ? AppColors.primary
                                        : _controller.selectedDay.value == e.key
                                            ? Colors.black
                                            : Colors.grey[500]),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${e.key + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: _controller.currentDay.value == e.key
                                        ? AppColors.primary
                                        : _controller.selectedDay.value == e.key
                                            ? Colors.black
                                            : Colors.grey[500]),
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTimeLine() {
    TripNode currentDay = _controller.tripNodes[_controller.selectedDay.value];
    return Column(
      children: currentDay.plans
          .asMap()
          .entries
          .map(
            (e) => buildPlanNode(e.value, e.key == 2, e.key == currentDay.plans.length - 1),
          )
          .toList(),
    );
  }

  Widget buildPlanNode(PlanNode plan, bool isCurrent, [bool isLast = false]) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isCurrent ? AppColors.primary : Colors.grey[400]!, width: 2),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Text(
                plan.time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                ),
              )
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 12,
                child: Center(
                  child: Container(
                    width: 1,
                    color: isCurrent ? AppColors.primary : Colors.grey[400]!,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: isLast ? 0 : 20),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), spreadRadius: -4, blurRadius: 18, offset: Offset(0, -2)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(right: BorderSide(color: isCurrent ? AppColors.primary : Colors.grey[400]!, width: 4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              plan.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildListDay(),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Địa điểm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), spreadRadius: -2, blurRadius: 24),
                ],
              ),
              child: Icon(
                Icons.add,
                color: AppColors.primary,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        buildTimeLine(),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chi tiêu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), spreadRadius: -2, blurRadius: 24),
                ],
              ),
              child: Icon(
                Icons.add,
                color: AppColors.primary,
              ),
            )
          ],
        ),
      ],
    );
  }
}
