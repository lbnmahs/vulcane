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

  Map<String, dynamic> toJson () => {
    'id': id,
    'name': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'profileImageUrl': profileImageUrl,
    'ownedCarIds': ownedCarIds,
    'wishlistCarIds': wishlistCarIds
  };

  factory VulcaneUser.fromJson(Map<String, dynamic> json) {
    return VulcaneUser(
      id: json['id'],
      fullName: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      ownedCarIds: json['ownedCarIds'],
      wishlistCarIds: json['wishlistCarIds']
    );
  }
}