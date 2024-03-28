// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:vulcane/data/auth/auth_repository.dart';
import 'package:vulcane/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // login with email and password
    on<LoginWithEmailPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.loginWithEmailAndPassword(event.email, event.password);
        if(user != null) {
          emit(AuthSuccess(user: VulcaneUser.fromFirebaseUser(user)));
        } else {
          emit(AuthFailure(message: 'Failed to login'));
        }
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    // register with email and password
    on<RegisterWithEmailPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.registerWithEmailAndPassword(
          event.email, event.password, event.fullName
        );
        if(user != null) {
          emit(AuthSuccess(user:user));
        } else {
          emit(AuthFailure(message: 'Failed to register'));
        }
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    // sign in with google
    on<SignInWithGoogle>((event, emit) async {
      emit(GoogleAuthLoading());
      try {
        final user = await authRepository.signInWithGoogle();
        if(user != null) {
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthFailure(message: 'Failed to sign in with Google'));
        }
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    // verify phone number and send OTP
    on<VerifyPhoneNumber>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.verifyPhoneNumber(
          event.phoneNumber, (verificationId) => emit(OTPSent())
        );
        emit(PhoneNumberVerificationSuccess());
      } catch (e) {
        emit(PhoneNumberVerificationFailure(message: e.toString()));
      }
    });

    // verify OTP and sign in user
    on<VerifyOTP>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.verifyOTP(
          event.verificationId, event.smsCode, event.phoneNumber
        );
        if(user != null) {
          emit(OTPVerificationSuccess(user: VulcaneUser.fromFirebaseUser(user)));
        } else {
          emit(OTPVerificationFailure(message: 'Failed to verify OTP'));
        }
      } catch (e) {
        emit(OTPVerificationFailure(message: e.toString()));
      }
    });

    // check auth event
    on<CheckAuthEvent>((event, emit) async {
      final user = await authRepository.getCurrentUser();
      if(user != null) {
        emit(AuthSuccess(user: VulcaneUser.fromFirebaseUser(user)));
      } else {
        emit(AuthFailure(message: 'Failed to check auth'));
      }
    });

    // sign out
    on<SignOut>((event, emit) async {
      emit(AuthLoading());
      try{
        await authRepository.signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });
  }
}
