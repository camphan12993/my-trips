import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/components/user_avatar.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/dialogs/add_spend_dialog.dart';
import 'package:intl/intl.dart';

class TripDetail extends GetView<TripDetailController> {
  const TripDetail({super.key});

  Widget buildExpenseDetailForMember(String id) {
    var userExpense = controller.getTotalOfMember(id);
    var diff = userExpense - controller.getTotal() / controller.members.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserAvatar(uid: id),
              Text(
                userExpense.toString(),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(${diff > 0 ? "+" : ""}$diff)',
              style: TextStyle(
                color: diff > 0 ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
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
          appBar: AppBar(
            title: Text(controller.trip.value!.name),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(
                    '${AppRoutes.trips}/${controller.id}/settings',
                    arguments: {
                      'trip': controller.trip.value,
                    },
                  )!
                      .then((value) {
                    controller.getTripById();
                  });
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    right: 12,
                    bottom: 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...controller.tripNodes
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.name.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        e.createdDate,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Agenda'),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  padding: const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Expense'),
                                              ElevatedButton(
                                                onPressed: () => Get.dialog(AddSpendDialog(
                                                  nodeId: e.id,
                                                )),
                                                style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  padding: const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(color: Colors.grey[100]),
                                            child: e.expenses.isNotEmpty
                                                ? Column(
                                                    children: [
                                                      ...e.expenses
                                                          .map((ep) => Container(
                                                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
                                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    UserAvatar(uid: ep.userId),
                                                                    Text(
                                                                      ep.value.toString(),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                          .toList(),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Total',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(
                                                              controller.getTotalInNode(e.expenses).toString(),
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : const Center(
                                                    child: Text('Please add more expense'),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text(
                                  'New',
                                  textAlign: TextAlign.center,
                                ),
                                content: Form(
                                    key: controller.formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: controller.nameController,
                                          decoration: const InputDecoration(labelText: 'Name'),
                                        )
                                      ],
                                    )),
                                actions: [
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller.addNode();
                                        Get.back();
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(Icons.add))
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 6)], color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            controller.isShowDetail.value = !controller.isShowDetail.value;
                          },
                          child: const Icon(Icons.more_horiz),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  controller.getTotal().toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Obx(
                            () => controller.isShowDetail.value
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                                    child: Column(
                                      children: controller.members.map((m) => buildExpenseDetailForMember(m.uid)).toList(),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
      return const Scaffold(
        body: Center(
          child: Text('No Data'),
        ),
      );
    });
  }
}
