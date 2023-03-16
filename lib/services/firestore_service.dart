import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedcare_admin/utilities/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseDb = FirebaseFirestore.instance;

  Future<void> logUser(User user) async {
    try {
      await _firebaseDb
          .collection(FirestoreConstants.adminsCollection)
          .doc(user.uid)
          .update(
        {
          'lastLogin': user.metadata.lastSignInTime,
        },
      );
    } catch (e) {
      throw Exception(e).toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersSnapshots() {
    return _firebaseDb
        .collection(FirestoreConstants.usersCollection)
        .snapshots();
  }

  Future<void> approveRegistration(String uid, bool value) async {
    try {
      await _firebaseDb
          .collection(FirestoreConstants.usersCollection)
          .doc(uid)
          .update(
        {
          'isApproved': value,
        },
      );
    } catch (e) {
      throw Exception(e).toString();
    }
  }
}
