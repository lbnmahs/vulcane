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

class SignOut extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
