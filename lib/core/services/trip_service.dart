import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_trips_app/models/plan_node.dart';
import 'package:my_trips_app/models/trip.dart';
import 'package:my_trips_app/models/trip_expense.dart';
import 'package:my_trips_app/models/trip_node.dart';

class TripService {
  Future<void> createTrip(Map<String, dynamic> payload) async {
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    DocumentReference result = await tripCollection.add(payload);
    await result.update({'id': result.id});
    await addTripNode(tripId: result.id, payload: {'date': payload['startDate']});
    var userCollection = FirebaseFirestore.instance.collection('users');
    for (var id in payload['memberIds']) {
      userCollection.doc(id).update({
        'tripIds': FieldValue.arrayUnion([result.id])
      });
    }
  }

  Future<List<Trip>> getTrips({required String uid}) async {
    List<Trip> trips = [];
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    QuerySnapshot result = await tripCollection.get();
    for (var d in result.docs) {
      trips.add(Trip.fromMap(d.data() as Map<String, dynamic>));
    }
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

  Future<void> addTripNode({required String tripId, required Map<String, dynamic> payload}) async {
    final CollectionReference tripNodes = FirebaseFirestore.instance.collection('trip_nodes');
    DocumentReference result = await tripNodes.add({
      'tripId': tripId,
      ...payload,
    });
    await result.update({'id': result.id});
  }

  Future<List<TripNode>> getListNodes({required String tripId}) async {
    List<TripNode> tripNodes = [];
    final CollectionReference tripNodesCollection = FirebaseFirestore.instance.collection('trip_nodes');
    var result = await tripNodesCollection.orderBy('createdDate').where('tripId', isEqualTo: tripId).get();
    for (var node in result.docs) {
      tripNodes.add(TripNode.fromMap(node.data()! as Map<String, dynamic>));
    }
    for (var node in tripNodes) {
      var expenseResult = await tripNodesCollection.doc(node.id).collection('expense').get();
      List<TripExpense> expenses = [];
      for (var e in expenseResult.docs) {
        expenses.add(TripExpense.fromMap(e.data()));
      }
      node.expenses = expenses;
      var plansResult = await tripNodesCollection.doc(node.id).collection('plans').get();
      List<PlanNode> plans = [];
      for (var e in plansResult.docs) {
        plans.add(PlanNode.fromMap(e.data()));
      }
      node.plans = plans;
    }
    return tripNodes;
  }

  Future<void> addExpense({required String nodeId, required Map<String, dynamic> payload}) async {
    var expenses = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('expense');
    var result = await expenses.add({...payload, 'nodeId': nodeId});
    await result.update({'id': result.id});
  }

  Future<void> addPlanNode({required String nodeId, required Map<String, dynamic> payload}) async {
    var tripPlans = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('plans');
    var result = await tripPlans.add(payload);
    await result.update({'id': result.id});
  }

  Future<void> updateExpense({required String nodeId, required String id, required Map<String, dynamic> payload}) async {
    var expense = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('expense').doc(id);
    await expense.update(payload);
  }

  Future<void> deleteExpense({required String nodeId, required String id}) async {
    await FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('expense').doc(id).delete();
    ;
  }
}
