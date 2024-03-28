part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailPassword({required this.email, required this.password});
}

class RegisterWithEmailPassword extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  RegisterWithEmailPassword({
    required this.email, required this.password, required this.fullName
  });
}

class SignInWithGoogle extends AuthEvent {}

class VerifyPhoneNumber extends AuthEvent {
  final String phoneNumber;
  final Function(String) codeSent;

  VerifyPhoneNumber({required this.phoneNumber, required this.codeSent});
}

class VerifyOTP extends AuthEvent {
  final String verificationId;
  final String smsCode;
  final String phoneNumber;

  VerifyOTP({
    required this.verificationId, required this.smsCode, required this.phoneNumber
  });
}

class CheckAuthEvent extends AuthEvent {}

class SignOut extends AuthEvent {}