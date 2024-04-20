import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:vulcane/middleware/auth/auth_bloc.dart';
import 'package:vulcane/views/widgets/custom_input.dart';

class PhoneOTPScreen extends StatefulWidget {
  const PhoneOTPScreen({super.key, required this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  var _isPhoneNumber = true;
  final _phoneNumberController = TextEditingController();

  void _verify () {
    if(_isPhoneNumber) {
      context.read<AuthBloc>().add(
        SendOTP(
          phoneNumber: _phoneNumberController.text, 
          uid: widget.uid, 
          codeSent: (verificationId) {
            _phoneNumberController.text = verificationId;
          }
        )
      );
      setState(() => _isPhoneNumber = false);
    } else {
      context.read<AuthBloc>().add(
        VerifyOTP(
          verificationId: _phoneNumberController.text, 
          smsCode: _phoneNumberController.text, 
          uid: widget.uid
        )
      );
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isPhoneNumber 
                  ? 'Enter your phone number' 
                  : 'Enter the sent OTP code',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Text(
                _isPhoneNumber 
                  ? 'We will send you a verification code' 
                  : 'Enter the code sent to ${_phoneNumberController.text}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              _isPhoneNumber
                ? InternationalPhoneNumberInput(
                    textFieldController: _phoneNumberController,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    inputDecoration: customInputDecoration(context: context, label: 'Phone Number'),
                    onInputChanged: (phone) => debugPrint(phone as String),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      showFlags: true,
                      leadingPadding: 10,
                      useBottomSheetSafeArea: true
                    ),                        
                  )
                : OtpTextField(
                    numberOfFields: 6,
                    borderColor: Theme.of(context).colorScheme.primaryContainer,
                    focusedBorderColor: Theme.of(context).colorScheme.onPrimary,
                    showFieldAsBox: true,
                    onCodeChanged: (code) {
                      debugPrint(code);
                    },
                  ),
              const SizedBox(height: 30),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: state is! AuthLoading ? _verify : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Center(
                        child: state is AuthLoading 
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            )
                          : Text(
                              _isPhoneNumber ? 'Send OTP' : 'Verify OTP',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
