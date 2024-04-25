import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:vulcane/models/user_model.dart';
import 'package:vulcane/utils/auth/auth_bloc.dart';
import 'package:vulcane/views/widgets/user_avatar.dart';
import 'package:vulcane/views/screens/auth/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final VulcaneUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  size: 20.0,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(SignOut());
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthScreen())
                  );
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              UserAvatar(
                imageUrl: user.profileImageUrl ?? '',
                radius: 60.0,
                name: user.fullName,
              ),
              const SizedBox(height: 30.0),
              ListTile(title: Text('Full Name: ${user.fullName}'),),
              ListTile(title: Text('Email: ${user.email}'),),
            ],
          ),
        ),
      ),
    );
  }
}
