import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:vulcane/utils/auth/auth_bloc.dart';
import 'package:vulcane/views/screens/tabs/home_tab.dart';
import 'package:vulcane/views/widgets/custom_input.dart';
import 'package:vulcane/views/widgets/toast_notifications.dart';

class PhoneOTPScreen extends StatefulWidget {
  const PhoneOTPScreen({super.key, required this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  var _isPhoneNumber = true;
  String _fullPhoneNumber = '';
  final _phoneNumberController = TextEditingController();
  List<TextEditingController>? _otpControllers;

  void _verify() => _isPhoneNumber ? _sendOTP() : _verifyOTP();
  
  void _sendOTP () {
    if(_fullPhoneNumber.isEmpty){ 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is empty')),
      );      
      return;
    }
    context.read<AuthBloc>().add(
      SendOTP(
        phoneNumber: _fullPhoneNumber,
        uid: widget.uid, 
        codeSent: (verificationId) {
          for (int i = 0; i < verificationId.length && i < _otpControllers!.length; i++) {
            _otpControllers![i].text = verificationId[i];
          }
        }
      )
    );
  }

  void _verifyOTP () {
    if (_otpControllers == null || _otpControllers!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP code is empty')),
      );
      return;
    }    
    String otpCode = _otpControllers!.map((controller) => controller.text).join();
    context.read<AuthBloc>().add(
      VerifyOTP(
        verificationId: otpCode, 
        smsCode: otpCode, 
        uid: widget.uid
      )
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _otpControllers?.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(_isPhoneNumber) {
          if(state is PhoneNumberVerificationSuccess) {
            showToastNotification(
              context: context, 
              type: ToastificationType.success, 
              title: 'OTP has been sent to $_fullPhoneNumber'
            );
            setState(() => _isPhoneNumber = false); 
          } else if (state is PhoneNumberVerificationFailure) {
            showToastNotification(
              context: context, 
              type: ToastificationType.error, 
              title: state.message
            );
          }
        } else {
          if(state is OTPVerificationSuccess) {
            showToastNotification(
              context: context, 
              type: ToastificationType.success, 
              title: "OTP has been verified successfully!"
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeTab(currentUser: state.user,),
              ),
            );
          } else if (state is OTPVerificationFailure) {
            showToastNotification(
              context: context, 
              type: ToastificationType.error, 
              title: state.message
            );
          }
        }
      },
      child: Scaffold(
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
                      : 'Enter the code sent to $_fullPhoneNumber',
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
                        onInputChanged:(phone) {
                          _fullPhoneNumber = phone.phoneNumber!;
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          showFlags: true,
                          leadingPadding: 10,
                          useBottomSheetSafeArea: true
                        ),                        
                      )
                    : OtpTextField(
                        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        numberOfFields: 6,
                        borderColor: Theme.of(context).colorScheme.primaryContainer,
                        focusedBorderColor: Theme.of(context).colorScheme.onPrimary,
                        showFieldAsBox: true,
                        onCodeChanged: (code) {debugPrint(code);},
                        handleControllers: (controllers) {
                          _otpControllers = controllers.whereType<TextEditingController>().toList();
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
        ),
    );
  }
}
