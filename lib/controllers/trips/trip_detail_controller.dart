import 'package:get/get.dart';
import 'package:my_trips_app/core/services/trip_service.dart';

import '../../models/trip.dart';

class TripDetailController extends GetxController {
  String? id;
  Rxn<Trip> trip = Rxn<Trip>();
  final TripService _tripService = TripService();
  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'];
    if (id != null) {
      getTripById();
    }
  }

  Future<void> getTripById() async {
    var result = await _tripService.getTripById(id: id!);
    if (result != null) {
      trip.value = result;
    }
  }
}
