import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_buzz_bytes/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Future<bool> login(email, password) async {
  final response = await http.post(
    Uri.parse('http://192.168.93.98:3000/api/v1/users/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> resData = jsonDecode(response.body);
    String token = resData['token'];
    // Store the JWT locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vitBuzzBytesToken', token);
    return true;
  } else {
    return false;
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome Back!",
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(
                  height: 40,
                ),

                Image.asset(
                  'assets/images/app_icon.png',
                  width: 120,
                  height: 120,
                ), // Placeholder for logo
                const SizedBox(height: 40),
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
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
                        hintStyle:
                            const TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text("Password",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodySmall)),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 94, 94, 94),
                              width: 0.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 94, 94, 94),
                              width: 0.7 // Set the border color here
                              ),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        hintText: "Enter your password",
                        hintStyle:
                            const TextStyle(fontWeight: FontWeight.w300)),
                    obscureText: true,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New to VITBuzzBytes?",
                        style: Theme.of(context).textTheme.bodySmall),
                    TextButton(
                        onPressed: () {},
                        child: Text("Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)))
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 55,
                  width: double
                      .infinity, // Make the button take all available width
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final loginStatus = await login(
                          emailController.text.trim(),
                          passwordController.text.trim());
                      if (loginStatus) {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Make the button less rounded
                      ),
                    ),
                    child: !isLoading
                        ? Text(
                            'Log in',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                    color: Colors.white),
                          )
                        : CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
