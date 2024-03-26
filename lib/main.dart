import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vulcane/data/auth/auth_data_provider.dart';
import 'package:vulcane/data/auth/auth_repository.dart';
import 'package:vulcane/firebase_options.dart';
import 'package:vulcane/middleware/auth/auth_bloc.dart';
import 'package:vulcane/views/screens/splash_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final AuthDataProvider authDataProvider = AuthDataProvider();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(authDataProvider),
        )
      ], 
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>()
            ),
          )
        ], 
        child: const MyApp(),
      )
    )
  );
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue.shade300,
    primary: const Color.fromRGBO(0, 77, 158, 1),
    secondary: const Color.fromRGBO(255, 111, 0, 1),
    background: const Color.fromRGBO(242, 242, 242, 1),
  ),
  textTheme: GoogleFonts.robotoTextTheme(),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: const Color.fromRGBO(255, 111, 0, 1),
    unselectedItemColor: Colors.grey.shade400,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vulcane',
      theme: theme,
      home: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthSuccess) {
                Navigator.of(context).pushReplacementNamed('/home');
              } else if(state is AuthFailure) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            }
          )
        ], 
        child: const SplashScreen()
      ),
    );
  }
}
