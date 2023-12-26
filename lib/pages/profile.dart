import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/providers/my_buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:vit_buzz_bytes/utils/buzz.dart';
import 'package:vit_buzz_bytes/widgets/image_picker_cropper.dart';
import 'package:vit_buzz_bytes/widgets/recent_posts_container.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late List<dynamic> buzzesJson;
  late List<Buzz> buzzes;
  String profilePicUrl = "";

  void profilePicSetter(String url) {
    setState(() {
      profilePicUrl = url;
    });
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    var url = Uri.parse('$server/api/v1/users/profile');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ref.read(tokenProvider)}',
      // Add other headers if needed
    };
    var response = await http.get(url, headers: headers);
    var responseJson = json.decode(response.body);
    buzzesJson = (responseJson['data']['buzzes']);
    if (responseJson['data']['user']['profilePic'] != 'default.jpg') {
      profilePicUrl =
          '$server/api/v1/users/img/${responseJson['data']['user']['profilePic']}';
    }

    buzzes = buzzesJson.map((json) => Buzz.fromJson(json)).toList();
    ref.read(mybuzzListProvider.notifier).state = buzzes;

    print(ref.read(mybuzzListProvider));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot);
          return Text('Error: ${snapshot.error}');
        } else {
          buzzesJson = (snapshot.data!['data']['buzzes']);
          buzzes = buzzesJson.map((json) => Buzz.fromJson(json)).toList();
          var myBuzzes = ref.watch(mybuzzListProvider);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImage(
                      networkImageUrl: profilePicUrl,
                      profilePicSetter: profilePicSetter,
                      isEditable: true,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      "@${snapshot.data!['data']['user']['userID']}",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 203, 203, 203)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 22,
                                      )),
                                ),
                              ],
                            ),
                          ),
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
                            snapshot.data!['data']['user']['email'],
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    const Color.fromARGB(255, 203, 203, 203)),
                          ),
                        ],
                      ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: myBuzzes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: RecentPostContainer(
                              buzz: myBuzzes[index],
                              profileFetcher: fetchProfileData,
                              showDeleteButton: true,
                            ),
                          );
                        },
                      ),
                    )
                  ]),
            ),
          );
        }
      },
    );
  }
}
