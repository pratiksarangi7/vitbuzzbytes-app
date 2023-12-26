import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/pages/user_details.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';

class VerifyOtp extends ConsumerStatefulWidget {
  final String email;
  const VerifyOtp({super.key, required this.email});

  @override
  ConsumerState<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  bool _startVerify = false;
  String otp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 70,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/otp_page.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Enter The OTP',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "We just sent to your email address @${widget.email}",
                style:
                    GoogleFonts.roboto(fontSize: 18, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              OtpTextField(
                  fieldWidth: 50,
                  borderRadius: BorderRadius.circular(3),
                  mainAxisAlignment: MainAxisAlignment.center,
                  numberOfFields: 6,
                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                  filled: true,
                  onSubmit: (code) async {
                    setState(() {
                      _startVerify = true;
                    });
                    otp = code;
                    var response = await http.post(
                      Uri.parse('$server/api/v1/users/verify-otp'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'email': widget.email,
                        'otp': otp,
                      }),
                    );
                    print(widget.email);
                    print(otp);

                    // If the server returns a 200 OK response, parse the token and save it
                    if (response.statusCode == 200) {
                      var token = jsonDecode(response.body)['token'];
                      // Save the token
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('vitBuzzBytesToken', token);
                      ref.read(tokenProvider.notifier).state = token;
                      setState(() {
                        _startVerify = false;
                      });
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserDetailsScreen()),
                        );
                      }
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter a valid OTP"),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _startVerify
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
