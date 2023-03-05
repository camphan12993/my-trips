import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_trips_app/models/app_user.dart';
import 'package:my_trips_app/models/user_payload.dart';

class UserService {
  Future<void> saveUser(
    UserPayload user,
  ) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(user.uid).set(user.toMap());
  }

  Future<AppUser> getUserById(
    String id,
  ) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot result = await userCollection.doc(id).get();
    return AppUser.fromMap(result.data() as Map<String, dynamic>);
  }

  Future<List<AppUser>> getListUser() async {
    List<AppUser> users = [];
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot result = await userCollection.get();
    result.docs.forEach((e) {
      users.add(AppUser.fromMap(e.data()! as Map<String, dynamic>));
    });
    return users;
  }
}
