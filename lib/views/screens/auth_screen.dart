import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vulcane/middleware/auth/auth_bloc.dart';
import 'package:vulcane/views/screens/home_tab.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication successful!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeTab(),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Hello, Welcome Back 👋' : 'Create Account 👋',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 40),

                  // First Name Field
                  if(!_isLogin)
                    Text(
                      'First Name',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (!_isLogin) const SizedBox(height: 8),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('fullName'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
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
                  Text(
                    'Email Address',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const ValueKey('email'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          width: 2
                        )
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onSaved: (value) => _enteredEmail = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password Field
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const ValueKey('password'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          width: 2
                        )
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded
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
                  const SizedBox(height: 40),

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
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: state is AuthLoading
                            ? Center( 
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : Center(
                              child: Text(
                                  _isLogin ? 'Login' : 'Register',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // or
                  Center(
                    child: Text(
                      'or',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign In Button
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(SignInWithGoogle());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Center(
                        child: Text(
                          _isLogin ? 'Sign in with Google' : 'Sign up with Google',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                
                  // Create Account/Login Button
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin ? 'Create an Account' : 'I already have an account',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
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
