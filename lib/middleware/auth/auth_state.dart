part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class GoogleAuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final VulcaneUser user;

  AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}

final class PhoneNumberVerificationSuccess extends AuthState {}

final class PhoneNumberVerificationFailure extends AuthState {
  final String message;

  PhoneNumberVerificationFailure({required this.message});
}

final class OTPSent extends AuthState {}

final class OTPVerificationSuccess extends AuthState {
  final VulcaneUser user;

  OTPVerificationSuccess({required this.user});
}

final class OTPVerificationFailure extends AuthState {
  final String message;

  OTPVerificationFailure({required this.message});
}