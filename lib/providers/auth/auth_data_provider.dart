import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return password.length >= 6 &&
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[a-z]')) &&
      password.contains(RegExp(r'[0-9]')) &&
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\-_+=~`/\[\]]'));
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

  // sign in with google
  Future<VulcaneUser?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if(googleUser == null) { throw Exception('Google sign in was cancelled');}
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential;
      try {
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        throw Exception('Firebase Auth error: ${e.code}');
      }
      User? user = userCredential.user;

      if (user != null) {
        // Checking if user already exists in Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // If user does not exist, we add them to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'full name': user.displayName,
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
            'phoneNumber': user.phoneNumber ?? '',
            'profileImageUrl': user.photoURL,
          });
        }
        return VulcaneUser(
          id: user.uid,
          fullName: user.displayName!,
          email: user.email!,
          phoneNumber: user.phoneNumber ?? '',
          profileImageUrl: user.photoURL,
        );
      }
      return null;
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // sending OTP
  Future<void> sendOtp(
    String phoneNumber, String uid, Function(String) codeSent
  ) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
          User? user = userCredential.user;
          if(user != null) {
            await FirebaseFirestore.instance.collection('users').doc(uid).update({
              'phoneNumber': phoneNumber,
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception('An error occurred: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch(e) {
      throw Exception('An error occurred: $e');
    }
  }

  // verify OTP and user sign in
  Future<User?> verifyOtp(
    String verificationId, String smsCode, String uid
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //get current user
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }
}
