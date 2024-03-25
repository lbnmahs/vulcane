import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:vulcane/models/user_model.dart';

class AuthDataProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email');
        case 'wrong-password':
          throw Exception('Wrong password provided for that user');
        default:
          throw Exception('An error occurred: ${e.code}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  bool isPasswordStrong(String password) {
    // Check if password meets your requirements
    // This is just an example, adjust the rules to fit your needs
    return password.length >= 6 &&
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[a-z]')) &&
      password.contains(RegExp(r'[0-9]')) &&
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
  //register with email and password
  Future<VulcaneUser?> registerWithEmailAndPassword(
    String email, String password, String fullName
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password
      );
      User? user = userCredential.user;
      if(user != null) {
        await user.updateDisplayName(fullName);
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'full name': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp()
        });
        return VulcaneUser(
          id: user.uid,
          fullName: fullName,
          email: email,
          phoneNumber: '',
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('The provided email is already in use');
        case 'invalid-email':
          throw Exception('The provided email is invalid');
        default:
          throw Exception('An error occurred: ${e.code}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // sign in with google
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
