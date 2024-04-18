import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:vulcane/middleware/auth/auth_bloc.dart';

class PhoneOTPScreen extends StatefulWidget {
  const PhoneOTPScreen({super.key, required this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  var _isPhoneNumber = true;
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(15),
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
                      : 'Enter the code sent to your phone',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  _isPhoneNumber
                    ? InternationalPhoneNumberInput(
                        textFieldController: _phoneNumberController,
                        inputDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.primaryContainer,
                          contentPadding: const EdgeInsets.all(10.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
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
                  ElevatedButton(
                    onPressed: () {
                      if(_isPhoneNumber) {
                        setState(() => _isPhoneNumber = false);
                        context.read<AuthBloc>().add(
                          SendOTP(
                            phoneNumber: _phoneNumberController.text, 
                            uid: widget.uid, 
                            codeSent: (verificationId) {
                              _phoneNumberController.text = verificationId;
                            }
                          )
                        );
                      } else {
                        context.read<AuthBloc>().add(
                          VerifyOTP(
                            verificationId: _phoneNumberController.text, 
                            smsCode: _phoneNumberController.text, 
                            uid: widget.uid
                          )
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isPhoneNumber ? 'Send OTP' : 'Verify OTP',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
