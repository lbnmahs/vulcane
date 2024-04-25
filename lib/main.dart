import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:vulcane/firebase_options.dart';
import 'package:vulcane/utils/auth/auth_bloc.dart';
import 'package:vulcane/views/screens/splash_screen.dart';
import 'package:vulcane/views/screens/tabs/home_tab.dart';
import 'package:vulcane/providers/auth/auth_repository.dart';
import 'package:vulcane/views/screens/auth/auth_screen.dart';
import 'package:vulcane/providers/auth/auth_data_provider.dart';

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
            )..add(CheckAuthEvent()),
          )
        ], 
        child: const MyApp(),
      )
    )
  );
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary:  Color.fromRGBO(1, 11, 19, 1),
    onPrimary: Color.fromRGBO(255, 255, 255, 1),
    secondary:  Color.fromRGBO(234, 43, 31, 1),
    onSecondary: Color.fromRGBO(255, 255, 255, 1),
    primaryContainer: Color.fromRGBO(37, 48, 49, 1),
    onPrimaryContainer: Color.fromRGBO(255, 255, 255, 0.6),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeTab(currentUser: state.user,),
                  ),
                );
              } else if(state is AuthFailure) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              }
            }
          )
        ], 
        child: const SplashScreen()
      ),
    );
  }
}
