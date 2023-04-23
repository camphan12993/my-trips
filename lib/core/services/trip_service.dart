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
    await addTripNode(tripId: result.id);
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

  Future<void> deleteTrip(id) async {
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    await tripCollection.doc(id).delete();
    final CollectionReference nodeCollection = FirebaseFirestore.instance.collection('trip_nodes');
    var result = await nodeCollection.where('tripId', isEqualTo: id).get();
    var batch = FirebaseFirestore.instance.batch();
    for (var e in result.docs) {
      batch.delete(e.reference);
    }
    batch.commit();
  }

  Future<Trip?> getTripById({required String id}) async {
    Trip? trip;
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    DocumentSnapshot<Object?> result = await tripCollection.doc(id).get();
    trip = Trip.fromMap(result.data() as Map<String, dynamic>);
    var expenseResult = await tripCollection.doc(id).collection('expense').get();
    List<TripExpense> expenses = [];
    for (var expense in expenseResult.docs) {
      expenses.add(TripExpense.fromMap(expense.data()));
    }
    trip.otherExpense.addAll(expenses);
    return trip;
  }

  Future<void> updateTrip({required String id, required Map<String, dynamic> payload}) async {
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    return await tripCollection.doc(id).update(payload);
  }

  Future<void> addTripNode({required String tripId}) async {
    final CollectionReference tripNodes = FirebaseFirestore.instance.collection('trip_nodes');
    DocumentReference result = await tripNodes.add({'tripId': tripId, 'createdDate': DateTime.now().toUtc().toString()});
    await result.update({'id': result.id});
  }

  Future<void> addTripPayedExpense({required String tripId, required Map<String, dynamic> payload}) async {
    final CollectionReference tripCollection = FirebaseFirestore.instance.collection('trips');
    return await tripCollection.doc(tripId).set({
      'payedExpenses': FieldValue.arrayUnion([payload])
    }, SetOptions(merge: true));
  }

  Future<void> deleteNode(String id) async {
    var tripNodes = FirebaseFirestore.instance.collection('trip_nodes').doc(id);
    await tripNodes.delete();
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
      var plansResult = await tripNodesCollection.doc(node.id).collection('plans').orderBy('time').get();
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
    var result = await expenses.add({...payload, 'createdAt': DateTime.now().toUtc().toString()});
    await result.update({'id': result.id});
  }

  Future<void> addTripOtherExpense({required String tripId, required Map<String, dynamic> payload}) async {
    var expenses = FirebaseFirestore.instance.collection('trips').doc(tripId).collection('expense');
    var result = await expenses.add({...payload, 'createdAt': DateTime.now().toUtc().toString()});
    await result.update({'id': result.id});
  }

  Future<void> updateTripOtherExpense({required String tripId, required String id, required Map<String, dynamic> payload}) async {
    var expenses = FirebaseFirestore.instance.collection('trips').doc(tripId).collection('expense').doc(id);
    await expenses.update(payload);
  }

  Future<void> deleteTripOtherExpense({required String tripId, required String id}) async {
    await FirebaseFirestore.instance.collection('trips').doc(tripId).collection('expense').doc(id).delete();
  }

  Future<void> addPlanNode({required String nodeId, required Map<String, dynamic> payload}) async {
    var tripPlans = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('plans');
    var result = await tripPlans.add(payload);
    await result.update({'id': result.id});
  }

  Future<void> updatePlanNode({required String nodeId, required String id, required Map<String, dynamic> payload}) async {
    var tripPlans = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('plans').doc(id);
    await tripPlans.update(payload);
  }

  Future<void> deletePlanNode({required String nodeId, required String id}) async {
    var tripPlans = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('plans').doc(id);
    await tripPlans.delete();
  }

  Future<void> updateExpense({required String nodeId, required String id, required Map<String, dynamic> payload}) async {
    var expense = FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('expense').doc(id);
    await expense.update(payload);
  }

  Future<void> deleteExpense({required String nodeId, required String id}) async {
    await FirebaseFirestore.instance.collection('trip_nodes').doc(nodeId).collection('expense').doc(id).delete();
  }
}
