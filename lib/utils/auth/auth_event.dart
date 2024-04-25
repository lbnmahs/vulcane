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

class SendOTP extends AuthEvent {
  final String phoneNumber;
  final String uid;
  final Function(String) codeSent;

  SendOTP({required this.phoneNumber, required this.uid, required this.codeSent});
}

class VerifyOTP extends AuthEvent {
  final String verificationId;
  final String smsCode;
  final String uid;

  VerifyOTP({
    required this.verificationId, required this.smsCode, required this.uid
  });
}

class CheckAuthEvent extends AuthEvent {}

class SignOut extends AuthEvent {}