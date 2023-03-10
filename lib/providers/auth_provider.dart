import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/services/auth_service.dart';
import 'package:schedcare_admin/services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserCredential? _userCredential;
  AuthService authService = AuthService();
  FirestoreService fireStoreService = FirestoreService();

  bool get isLoading => _isLoading;
  User? get isLoggedIn => authService.currentUser;

  setLoading(bool loader) {
    _isLoading = loader;
    notifyListeners();
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    try {
      _userCredential =
          await authService.logInWithEmailAndPassword(email, password);
      User? user = _userCredential!.user;

      await fireStoreService.logUser(user!);

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception(e).toString();
    }
  }

  Future<void> signOut() async {
    setLoading(true);
    try {
      await authService.signOut();
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception(e).toString();
    }
  }

  Stream<User?> get userStream {
    return authService.userStream();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(),
);

final authStateChangeProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
