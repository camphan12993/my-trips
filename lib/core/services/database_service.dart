import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_trips_app/models/user_payload.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    required this.uid,
  });

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> saveUser(UserPayload user) async {
    return await userCollection.doc(uid).set(user.toMap());
  }
}
