import 'package:firebase_auth/firebase_auth.dart';

class VulcaneUser {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final List<String>? ownedCarIds;
  final List<String>? wishlistCarIds;

  VulcaneUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.ownedCarIds,
    this.wishlistCarIds
  });


  factory VulcaneUser.fromFirebaseUser(User user) {
    return VulcaneUser(
      id: user.uid,
      fullName: user.displayName!,
      email: user.email!,
      phoneNumber: user.phoneNumber ?? '',
      profileImageUrl: user.photoURL,
    );
  }
}