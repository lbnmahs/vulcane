import 'package:flutter/material.dart';

class PhoneOTPScreen extends StatefulWidget {
  const PhoneOTPScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Phone OTP Screen'),
      ),
    );
  }
}
