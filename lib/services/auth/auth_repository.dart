import 'package:firebase_auth/firebase_auth.dart';

import 'package:vulcane/services/auth/auth_data_provider.dart';
import 'package:vulcane/models/user_model.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider;

  const AuthRepository(this.authDataProvider);

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    return await authDataProvider.loginWithEmailAndPassword(email, password);
  }

  Future<VulcaneUser?> registerWithEmailAndPassword(
    String email, String password, String fullName
  ) async {
    return await authDataProvider.registerWithEmailAndPassword(email, password, fullName);
  }
  
  Future<VulcaneUser?> signInWithGoogle() async {
    return await authDataProvider.signInWithGoogle();
  }

  Future<void> verifyPhoneNumber(String phoneNumber, String uid, Function(String) codeSent) async {
    return await authDataProvider.verifyPhoneNumber(phoneNumber, uid, codeSent);
  }

  Future<User?> verifyOTP(
    String verificationId, String smsCode, String uid
  ) async {
    return await authDataProvider.verifyOTP(verificationId, smsCode, uid);
  }

  Future<void> signOut() async {
    return await authDataProvider.signOut();
  }

  Future<User?> getCurrentUser() async {
    return await authDataProvider.getCurrentUser();
  }
}
