import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
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
                              .onSurface
                              .withOpacity(0.4)),
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
                Container(
                  height: 45,
                  width: double
                      .infinity, // Make the button take all available width
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Make the button less rounded
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w900, fontSize: 17),
                    ),
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
