import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:vulcane/middleware/auth/auth_bloc.dart';
import 'package:vulcane/views/screens/auth/phone_otp_screen.dart';
import 'package:vulcane/views/screens/tabs/home_tab.dart';
import 'package:vulcane/views/widgets/custom_input.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredFullName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isPasswordObscured = true;

  void _authenticate() {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    _form.currentState!.save();

    if(_isLogin) {
      context.read<AuthBloc>().add(
        LoginWithEmailPassword(
          email: _enteredEmail, password: _enteredPassword
        )
      );
    } else {
      context.read<AuthBloc>().add(
        RegisterWithEmailPassword(
          email: _enteredEmail, 
          password: _enteredPassword, 
          fullName: _enteredFullName
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          final authFailNotification = toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: Text(state.message),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            boxShadow: lowModeShadow,
          );
          toastification.dismiss(authFailNotification);
        } else if (state is AuthSuccess) {
          final authSuccessNotification = toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text("Authentication Successful"),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            boxShadow: lowModeShadow,
          );
          toastification.dismiss(authSuccessNotification);
          if(_isLogin) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeTab(currentUser: state.user,),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PhoneOTPScreen(uid: state.user.id,),
              ),
            );
          }

        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Sign In' : 'Sign Up',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _isLogin ? 'Please log in to continue' : 'Please register to join',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Sign In Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  state is! GoogleAuthLoading && state is! AuthLoading
                                    ? context.read<AuthBloc>().add(SignInWithGoogle()) 
                                    : null;
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15
                                  ),
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: state is GoogleAuthLoading 
                                  ? const CircularProgressIndicator()
                                  : const FaIcon(FontAwesomeIcons.google),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10,),
                        // Apple Sign In Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.apple,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            )
                          ),
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 30),

                  // or
                  Center(
                    child: Text(
                      'or',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // First Name Field
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('fullName'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      keyboardType: TextInputType.name,
                      decoration: customInputDecoration(context: context, label: 'Full Name'),
                      onSaved: (value) => _enteredFullName = value!,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                  if (!_isLogin) const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    key: const ValueKey('email'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: customInputDecoration(context: context, label: 'Email Address'),
                    onSaved: (value) => _enteredEmail = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    key: const ValueKey('password'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    decoration: customInputDecoration(
                      context: context, 
                      label: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () {
                          setState(() => _isPasswordObscured = !_isPasswordObscured);
                        },
                      )
                    ),
                    obscureText: _isPasswordObscured,
                    onSaved: (value) => _enteredPassword = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.trim().length < 6) {
                        return 'Password must be at least 5 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),

                  // Login/Create Account Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: state is! AuthLoading ? _authenticate: null,
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
                                  _isLogin ? 'Log In' : 'Register',
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
                  const SizedBox(height: 20),
                
                  // Create Account/Login Button
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin ? 'Don\'t have an account?' : 'Already have an account?',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin ? 'Register' : 'Log in',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
