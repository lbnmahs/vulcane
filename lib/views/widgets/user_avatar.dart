import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key, required this.imageUrl, required this.radius, required this.name
  });

  final String imageUrl;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : null,
      child: imageUrl.isEmpty
        ? Text(name[0].toUpperCase())
        : null,
      onBackgroundImageError: (exception, stackTrace) {
        CircleAvatar(
          radius: radius,
          child: Text(name[0].toUpperCase()),
        );
      },
    );
  }
}