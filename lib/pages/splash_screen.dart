import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/pages/base_screen.dart';
import 'package:vit_buzz_bytes/pages/login.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:vit_buzz_bytes/providers/user_id_provider.dart';
import 'package:vit_buzz_bytes/utils/buzz.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('vitBuzzBytesToken');
    if (token != null) {
      ref.read(tokenProvider.notifier).state = token;
      print("token not null, token: $token");
      var response = http.Response('', 400); // Default value
      try {
        response = await http.get(
          Uri.parse('$server/api/v1/buzzes/view-buzzes'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
        print("response got");
      } catch (e) {
        print("Error occured: $e");
      }

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final buzzes =
            jsonData['data'].map<Buzz>((item) => Buzz.fromJson(item)).toList();
        print(buzzes);
        ref.read(buzzListProvider.notifier).state = buzzes;
        ref.read(userIdProvider.notifier).state = jsonData['user'];
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BaseScreen()),
          );
        }
      }
    } else {
      if (mounted) {
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
              width: 300,
              height: 300,
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
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
