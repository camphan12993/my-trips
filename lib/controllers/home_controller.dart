import 'package:get/get.dart';
import 'package:my_trips_app/controllers/auth/auth_controller.dart';
import 'package:my_trips_app/core/app_routes.dart';
import 'package:my_trips_app/core/services/index.dart';
import 'package:my_trips_app/core/services/trip_service.dart';
import 'package:my_trips_app/models/trip.dart';

class HomeController extends GetxController {
  AuthService authService = AuthService();
  TripService _tripService = TripService();
  AuthController _authController = Get.find();
  RxList<Trip> trips = RxList([]);
  Future<void> signout() async {
    await authService.signOut();
    Get.offAndToNamed(AppRoutes.login);
  }

  @override
  void onInit() {
    getTrips();
    super.onInit();
  }

  Future<void> getTrips() async {
    var result = await _tripService.getTrips(uid: _authController.user!.uid);
    trips.clear();
    trips.addAll(result);
  }
}
