import 'package:flutter/material.dart';
import 'package:vit_buzz_bytes/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            displayLarge: GoogleFonts.outfit(
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
            ),
            displayMedium:
                GoogleFonts.outfit(fontSize: 30.0, fontWeight: FontWeight.bold),
            bodyMedium: GoogleFonts.inter(fontSize: 22),
            bodySmall: GoogleFonts.inter(fontSize: 14)),
        colorScheme: const ColorScheme(
          primary: Color.fromRGBO(227, 169, 38, 1), // Button background color
          onPrimary: Colors.white, // Button text color
          surface: Color.fromRGBO(38, 36, 31, 1), // Background color
          onSurface:
              Color.fromRGBO(216, 216, 216, 1), // Text color on background
          secondary: Color.fromRGBO(227, 169, 38,
              1), // Secondary color (can be used for other UI elements)
          onSecondary: Colors.white, // Text color on secondary color
          error: Colors.red, // Error color
          onError: Colors.white, // Text color on error color
          background: Color.fromRGBO(38, 36, 31, 1), // App background color
          onBackground: Colors.white, // Text color on app background color
          brightness:
              Brightness.dark, // Overall brightness of this color scheme
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
