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
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      foregroundImage: imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : null,
      child: Text(
        name[0].toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primaryContainer,
          fontSize: radius / 1.2,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}