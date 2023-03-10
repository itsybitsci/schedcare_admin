import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  final String uid;
  final String email;
  final String role;
  final DateTime lastLogin;
  final DateTime createdAt;

  Admin(
      {required this.uid,
      required this.email,
      required this.role,
      required this.lastLogin,
      required this.createdAt});

  factory Admin.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    return Admin(
      uid: snapshot.id,
      email: userData['email'],
      role: userData['role'],
      lastLogin: userData['lastLogin'].toDate(),
      createdAt: userData['createdAt'].toDate(),
    );
  }
}
