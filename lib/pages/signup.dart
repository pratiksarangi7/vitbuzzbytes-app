import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vit_buzz_bytes/pages/login.dart';
import 'package:vit_buzz_bytes/pages/verifyotp.dart';
import 'package:vit_buzz_bytes/constants/server.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  bool _startOtp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sign Up", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(
              height: 27,
            ),

            Image.asset(
              'assets/images/app_icon.png',
              width: 180,
              height: 180,
            ), // Placeholder for logo
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text("Email",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall),
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(
                            255, 94, 94, 94), // Set the border color here
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 94, 94, 94),
                          width: 0.7 // Set the border color here
                          ),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w300)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String pattern =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter a valid email address'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _startOtp = true;
                      });
                      final response = await http.post(
                        Uri.parse('$server/api/v1/users/get-otp'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'email': email,
                        }),
                      );
                      emailController.clear();
                      if (response.statusCode == 200 && context.mounted) {
                        print('OTP sent to ${emailController.text}');
                        setState(() {
                          _startOtp = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyOtp(email: email)));
                      } else {
                        // If the server returns an unexpected response,
                        // then throw an exception.
                        throw Exception('Failed to send OTP');
                      }
                    },
                    child: _startOtp
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Get OTP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already registered? ",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: Text("Log in",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary)))
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
