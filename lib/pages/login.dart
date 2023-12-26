import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/pages/base_screen.dart';
import 'package:vit_buzz_bytes/pages/signup.dart';
import 'package:vit_buzz_bytes/pages/verifyotp.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:vit_buzz_bytes/providers/user_id_provider.dart';
import 'package:vit_buzz_bytes/utils/buzz.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<bool> login(
      StateController<String> userIdController, email, password) async {
    final response = await http.post(
      Uri.parse('$server/api/v1/users/login'),
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
      print(token);
      userIdController.state = resData['user'];
      // Store the JWT locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('vitBuzzBytesToken', token);
// pasting here:
      var response2 = http.Response('', 400); // Default value
      ref.read(tokenProvider.notifier).state = token;
      try {
        response2 = await http.get(
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
      if (response2.statusCode == 200) {
        final jsonData = jsonDecode(response2.body);
        final buzzes =
            jsonData['data'].map<Buzz>((item) => Buzz.fromJson(item)).toList();
        print(buzzes);
        ref.read(buzzListProvider.notifier).state = buzzes;
        ref.read(userIdProvider.notifier).state = jsonData['user'];
      }
      return true;
    } else {
      return false;
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final userIdController = ref.watch(userIdProvider.notifier);
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
                  height: 20,
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
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
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
                          userIdController,
                          emailController.text.trim(),
                          passwordController.text.trim());

                      if (loginStatus) {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BaseScreen()),
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
