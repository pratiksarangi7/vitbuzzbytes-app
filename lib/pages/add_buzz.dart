import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'dart:convert';

import 'package:vit_buzz_bytes/utils/buzz.dart';

class AddBuzzScreen extends ConsumerStatefulWidget {
  const AddBuzzScreen({super.key});

  @override
  ConsumerState<AddBuzzScreen> createState() => _AddBuzzScreenState();
}

class _AddBuzzScreenState extends ConsumerState<AddBuzzScreen> {
  final _controller = TextEditingController();
  bool _isAnonymous = false;
  final _focusNode = FocusNode();
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus(); // Request focus when the screen is opened
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove focus when anywhere other than the TextFormField is tapped
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                minLines: 10,
                style: GoogleFonts.merriweather(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                  // contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'anonymous',
                        style:
                            GoogleFonts.lato(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Switch(
                        inactiveThumbColor: Colors.grey,
                        value: _isAnonymous,
                        onChanged: (value) {
                          setState(() {
                            _isAnonymous = value;
                          });
                        },
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: <String>[
                      'general',
                      'lost and found',
                      'events',
                      'ffcs',
                      'cab sharing'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        String text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          var url =
                              Uri.parse('$server/api/v1/buzzes/post-buzz');
                          var body = {
                            'text': text,
                            'category': _selectedCategory.replaceAll(" ", ""),
                          };
                          if (_isAnonymous) {
                            body['anonymous'] = 'true';
                            print('anonymous mode posted');
                          }

                          final token = ref.read(tokenProvider);
                          var headers = {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token',
                            // Add other headers if needed
                          };
                          print(body);
                          var response = await http.post(url,
                              body: jsonEncode(body), headers: headers);

                          if (response.statusCode == 201) {
                            _controller.clear();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Buzz posted successfully')), // Show a SnackBar
                              );
                            }
                            var newBuzzes = await http.get(
                              Uri.parse('$server/api/v1/buzzes/view-buzzes'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': 'Bearer $token',
                              },
                            );
                            if (newBuzzes.statusCode == 200) {
                              final jsonData = jsonDecode(newBuzzes.body);
                              final buzzes = jsonData['data']
                                  .map<Buzz>((item) => Buzz.fromJson(item))
                                  .toList();
                              ref.read(buzzListProvider.notifier).state =
                                  buzzes;
                            }
                          } else {
                            print(response.body);
                          }
                        }
                      },
                      child: Text('Post Buzz',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white)))),
            ],
          ),
        ),
      ),
    );
  }
}
