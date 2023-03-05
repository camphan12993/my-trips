import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_trips_app/models/trip.dart';

class TripService {
  Future<void> createTrip({required String name, required String adminId}) async {
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    DocumentReference result = await tripCollection.add({'id': '', 'name': name, 'adminId': adminId});
    await result.update({'id': result.id});
    final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(adminId);
    await userRef.update({
      'trips': FieldValue.arrayUnion([result.id])
    });
  }

  Future<List<Trip>> getTrips({required String uid}) async {
    List<Trip> trips = [];
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    QuerySnapshot result = await tripCollection.get();
    result.docs.forEach((d) {
      trips.add(Trip.fromMap(d.data() as Map<String, dynamic>));
    });
    return trips;
  }

  Future<Trip?> getTripById({required String id}) async {
    Trip? trip;
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    DocumentSnapshot<Object?> result = await tripCollection.doc(id).get();
    trip = Trip.fromMap(result.data() as Map<String, dynamic>);
    return trip;
  }

  Future<void> updateTrip({required String id, required Map<String, dynamic> payload}) async {
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    return await tripCollection.doc(id).update(payload);
  }
}
