import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vit_buzz_bytes/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
              displayLarge: GoogleFonts.outfit(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
              displayMedium: GoogleFonts.outfit(
                  fontSize: 30.0, fontWeight: FontWeight.bold),
              displaySmall:
                  GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700),
              bodyMedium: GoogleFonts.inter(fontSize: 22),
              bodySmall: GoogleFonts.lato(fontSize: 13),
              titleSmall: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500)),
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
            primaryContainer: Color.fromRGBO(61, 58, 51, 1),
            brightness:
                Brightness.dark, // Overall brightness of this color scheme
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
