import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_trips_app/models/user_payload.dart';

class DatabaseService {
  Future<void> saveUser(
    UserPayload user,
  ) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(user.uid).set(user.toMap());
  }
}
