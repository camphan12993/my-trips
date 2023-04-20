import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/index.dart';
import 'package:intl/intl.dart';
import 'package:my_trips_app/core/app_colors.dart';
import 'package:my_trips_app/core/app_constants.dart';
import 'package:my_trips_app/core/app_styles.dart';
import 'package:my_trips_app/models/app_currency.dart';
import 'package:my_trips_app/models/trip_member.dart';
import 'package:my_trips_app/widgets/data_placeholder.dart';

class TripSettings extends StatelessWidget {
  final TripDetailController _controller = Get.find();

  TripSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tên chuyến đi',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: _controller.nameController,
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
                Text(
                  'Ngày khởi hành',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: _controller.startDateController,
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
                            _controller.formSelectedDate.value = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2060),
                            );
                            if (_controller.formSelectedDate.value != null) {
                              _controller.startDateController.text = DateFormat('dd-MM-yyyy').format(_controller.formSelectedDate.value!);
                            }
                          },
                          child: const Icon(Icons.calendar_month))),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Tiền tệ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: appInputDecoration,
                  value: _controller.selectedCurrency.value,
                  onChanged: (String? value) {
                    if (value != null) {
                      _controller.selectedCurrency.value = value;
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn tiền tệ';
                    }
                    return null;
                  },
                  hint: const Text('Tiền tệ'),
                  items: AppConstants.currencies.map<DropdownMenuItem<String>>((AppCurrency value) {
                    return DropdownMenuItem<String>(
                      value: value.local,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Thành viên',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: appInputDecoration,
                        value: _controller.selectedMember.value,
                        onChanged: (String? value) {
                          if (value != null) {
                            _controller.selectedMember.value = value;
                          }
                        },
                        hint: const Text('Chọn thành viên'),
                        items: _controller.membersDropdown.map<DropdownMenuItem<String>>((TripMember value) {
                          return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                      onPressed: () => _controller.addMember(_controller.selectedMember.value!),
                      child: const Text('Thêm'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _controller.members.isNotEmpty
                    ? Column(
                        children: _controller.members
                            .map((u) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        '${u.name} ${u.id == _controller.trip.value!.adminId ? "(admin)" : ""}',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      if (u.id != _controller.trip.value!.adminId)
                                        GestureDetector(
                                          onTap: () => _controller.deleteMember(u),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        )
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: DataPlaceholder(text: 'Chưa có thành viên nào'),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: _controller.updateTrip,
            child: const Text('Lưu'),
          )
        ],
      ),
    );
  }
}
