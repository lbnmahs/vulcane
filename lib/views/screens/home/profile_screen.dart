import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:vulcane/models/user_model.dart';
import 'package:vulcane/views/widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final VulcaneUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            UserAvatar(
              imageUrl: user.profileImageUrl ?? '',
              radius: 60.0,
              name: user.fullName,
            ),
            const SizedBox(height: 20.0),
            ListTile(
              title: Text(user.fullName),
              subtitle: const Text('Full Name'),
            ),
            ListTile(
              title: Text(user.email),
              subtitle: const Text('Email'),
            ),
            ListTile(
              title: Text(user.phoneNumber),
              subtitle: const Text('Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}
