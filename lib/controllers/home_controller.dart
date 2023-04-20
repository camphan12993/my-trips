import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/core/services/index.dart';
import 'package:my_trips_app/core/services/trip_service.dart';
import 'package:my_trips_app/models/trip.dart';

class HomeController extends GetxController {
  AuthService authService = AuthService();
  final TripService _tripService = TripService();
  final AuthController _authController = Get.find();
  RxList<Trip> trips = RxList([]);
  Future<void> signout() async {
    await authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onInit() {
    getTrips();
    super.onInit();
  }

  Future<void> getTrips() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    try {
      var result = await _tripService.getTrips(uid: _authController.user!.uid);
      trips.clear();
      trips.addAll(result);
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteTrip(String id) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await _tripService.deleteTrip(id);
    EasyLoading.dismiss();
  }
}
