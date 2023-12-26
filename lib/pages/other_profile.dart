import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:vit_buzz_bytes/utils/buzz.dart';
import 'package:vit_buzz_bytes/widgets/recent_posts_container.dart';

class OtherProfilePage extends ConsumerStatefulWidget {
  final String userId;

  const OtherProfilePage({super.key, required this.userId});

  @override
  OtherProfilePageState createState() => OtherProfilePageState();
}

class OtherProfilePageState extends ConsumerState<OtherProfilePage> {
  Future<Map<String, dynamic>> fetchUserData() async {
    final token = ref.watch(tokenProvider);
    final response = await http.get(
      Uri.parse('$server/api/v1/users/other-profile/${widget.userId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // replace with your actual token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var user = snapshot.data!['data']['user'];
            print(user['userID']);
            var buzzes = snapshot.data!['data']['buzzes'];
            print('buzzes: $buzzes');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: ListView(
                children: <Widget>[
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                        '$server/api/v1/users/img/${user['profilePic']}'),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          '@${user['userID']}',
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 203, 203, 203)),
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Registered Email", // Use the data from the response
                    style: GoogleFonts.orienta(
                        color: const Color.fromARGB(255, 131, 131, 131),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    user['email'],
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 203, 203, 203)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("Recent Posts",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ...buzzes.map((buzz) {
                    final thisBuzz = Buzz.fromJson(buzz);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RecentPostContainer(
                          buzz: thisBuzz,
                          profileFetcher: () {},
                          showDeleteButton: false),
                    );
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
