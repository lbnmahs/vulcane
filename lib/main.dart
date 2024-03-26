import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vulcane/firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
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
      title: 'Your app name',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your Title here'),
        ),
        body: const Center(
          child: Text('Hello World, of course'),
        ),
      ),
    );
  }
}
