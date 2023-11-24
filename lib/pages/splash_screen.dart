import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_buzz_bytes/pages/base_screen.dart';
import 'package:vit_buzz_bytes/pages/home.dart';
import 'package:vit_buzz_bytes/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('vitBuzzBytesToken');

    if (token != null) {
      print("token not null, token: $token");
      var response = http.Response('', 400); // Default value
      try {
        response = await http.get(
          Uri.parse('http://192.168.93.98:3000/api/v1/buzzes/view-buzzes'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        print("Error occured: $e");
      }

      print("REquest sent, token: $token");
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BaseScreen()),
          );
        }
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "VITBuzzBytes",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
