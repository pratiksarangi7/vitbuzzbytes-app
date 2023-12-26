import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/pages/splash_screen.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';

InputDecoration textFieldDecorator(String hintText, Icon prefixIcon) {
  return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 94, 94, 94), // Set the border color here
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 94, 94, 94),
            width: 0.7 // Set the border color here
            ),
      ),
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: const TextStyle(fontWeight: FontWeight.w300));
}

class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 80,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Text("VITBuzzBytes",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 40,
                      )),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/images/app_icon.png',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: userIDController,
                decoration: textFieldDecorator(
                    "Enter a unique user ID", const Icon(Icons.person)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: textFieldDecorator(
                    "Enter password", const Icon(Icons.lock_outline_rounded)),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: textFieldDecorator(
                  "Confirm password",
                  const Icon(Icons.lock_outline_rounded),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Make the button less rounded
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                        ),
                      );
                      return;
                    }
                    final token = ref.read(tokenProvider);
                    var response = await http.post(
                      Uri.parse('$server/api/v1/users/signup'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': 'Bearer $token'
                      },
                      body: jsonEncode(<String, String>{
                        'userID': userIDController.text,
                        'password': passwordController.text,
                        'confirmPassword': confirmPasswordController.text,
                      }),
                    );

                    if (response.statusCode == 201 && context.mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SplashScreen()));
                    } else {
                      // If the server did not return a 201 CREATED response,
                      // then throw an exception.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to sign up'),
                        ),
                      );
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text('Sign Up',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
