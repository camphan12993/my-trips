import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_trips_app/core/services/user_service.dart';
import 'package:my_trips_app/models/app_user.dart';
import 'package:my_trips_app/models/user_payload.dart';

class AuthService {
  final UserService _userService = UserService();
  Future<AppUser> createUsernameAccount({required String name, required String username}) async {
    try {
      final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
      var existUser = await userCollection.where('username', isEqualTo: username).get();
      if (existUser.docs.isNotEmpty) {
        throw ('Username đã tồn tại');
      }
      var result = await userCollection.add({'name': name, 'username': username});
      await result.update({'uid': result.id});
      var user = await result.get();
      return AppUser.fromMap(user.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? '');
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<AppUser> loginUsername({required String username}) async {
    try {
      final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
      var existUser = await userCollection.where('username', isEqualTo: username).get();
      if (existUser.docs.isNotEmpty) {
        return AppUser.fromMap(existUser.docs.first.data() as Map<String, dynamic>);
      }
      throw ('Người dùng không tồn tại');
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? '');
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<User?> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      await _userService.saveUser(
        UserPayload(
          name: name,
          email: email,
          uid: user.uid,
        ),
      );
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  // For signing in an user (have already registered)
  Future<AppUser?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AppUser? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        var id = userCredential.user!.uid;
        user = await _userService.getUserById(id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

  Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
