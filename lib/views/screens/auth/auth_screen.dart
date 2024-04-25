import 'package:flutter/material.dart';
import 'package:vulcane/views/widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: AuthForm()
        )
      ),
    );
  }
}
