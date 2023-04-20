import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/models/app_user.dart';

import 'package:my_trips_app/models/trip_expense.dart';

import '../controllers/auth/auth_controller.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../core/app_styles.dart';
import '../core/services/trip_service.dart';
import '../models/app_currency.dart';

class AddTripDialog extends StatefulWidget {
  final String? nodeId;
  final TripExpense? expense;
  const AddTripDialog({
    super.key,
    this.nodeId,
    this.expense,
  });

  @override
  State<AddTripDialog> createState() => _AddTripDialogState();
}

class _AddTripDialogState extends State<AddTripDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String selectedCurrency = AppConstants.currencies[0].local;

  final TripService _tripService = TripService();
  final AuthController _authController = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Chuyến đi mới',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Tên chuyến đi',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: startDateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn ngày';
                  }
                  return null;
                },
                readOnly: true,
                decoration: InputDecoration(
                    hintText: 'Ngày khởi hành',
                    suffixIcon: GestureDetector(
                        onTap: () async {
                          selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2060),
                          );
                          if (selectedDate != null) {
                            startDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
                          }
                        },
                        child: const Icon(Icons.calendar_month))),
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: appInputDecoration,
                value: selectedCurrency,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedCurrency = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn tiền tệ';
                  }
                  return null;
                },
                hint: const Text('Loại tiền'),
                items: AppConstants.currencies.map<DropdownMenuItem<String>>((AppCurrency value) {
                  return DropdownMenuItem<String>(
                    value: value.local,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  AppUser user = _authController.user!;
                  var currency = AppConstants.currencies.firstWhere((a) => a.local == selectedCurrency);

                  await _tripService.createTrip({
                    'name': nameController.text,
                    'adminId': user.uid,
                    'startDate': DateFormat('yyyy-MM-dd').format(selectedDate!),
                    'members': [
                      {'id': user.uid, 'name': user.name}
                    ],
                    'currency': currency.name,
                    'locale': currency.local,
                  });
                  Get.back(result: true);
                } catch (e) {
                  print(e);
                }

                EasyLoading.dismiss();
                Get.back();
              }
            },
            child: const Text('Tạo'),
          ),
        )
      ],
    );
  }
}
