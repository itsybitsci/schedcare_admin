import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/services/auth_service.dart';
import 'package:schedcare_admin/services/firestore_service.dart';

class FirebaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggingIn = false;
  UserCredential? _userCredential;
  AuthService authService = AuthService();
  FirestoreService fireStoreService = FirestoreService();

  bool get isLoading => _isLoading;

  bool get getLoggingIn => _isLoggingIn;

  User? get isLoggedIn => authService.currentUser;

  setLoading(bool loader) {
    _isLoading = loader;
    notifyListeners();
  }

  setLoggingIn(bool loader) {
    _isLoggingIn = loader;
    notifyListeners();
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    setLoggingIn(true);
    try {
      _userCredential =
          await authService.logInWithEmailAndPassword(email, password);
      User? user = _userCredential!.user;

      await fireStoreService.logUser(user!);

      setLoading(false);
      setLoggingIn(false);
      notifyListeners();
    } on FirebaseException catch (e) {
      setLoading(false);
      setLoggingIn(false);
      throw Exception(e).toString();
    }
  }

  Future<void> signOut() async {
    setLoading(true);
    setLoggingIn(true);
    try {
      await authService.signOut();
      setLoading(false);
      setLoggingIn(false);
      notifyListeners();
    } on FirebaseException catch (e) {
      setLoading(false);
      setLoggingIn(false);
      throw Exception(e).toString();
    }
  }

  Stream<User?> get userStream {
    return authService.userStream();
  }

  Future<void> approveRegistration(String uid, bool value) async {
    setLoading(true);
    try {
      await fireStoreService.approveRegistration(uid, value);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception(e).toString();
    }
  }
}

final firebaseProvider = ChangeNotifierProvider<FirebaseProvider>(
  (ref) => FirebaseProvider(),
);

final authStateChangeProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
