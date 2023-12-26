import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:http/http.dart' as http;
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'dart:convert';

import 'package:vit_buzz_bytes/providers/user_id_provider.dart';
import 'package:vit_buzz_bytes/utils/comment.dart';

class AddComment extends ConsumerStatefulWidget {
  final String buzzID;
  const AddComment({super.key, required this.buzzID});

  @override
  ConsumerState<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends ConsumerState<AddComment> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add new comment',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final content = _controller.text.trim();
              if (content.isNotEmpty) {
                final reqdBuzz = ref
                    .read(buzzListProvider)
                    .firstWhere((element) => element.id == widget.buzzID);
                final newComment = BuzzComment(
                    text: content,
                    userID: ref.read(userIdProvider),
                    createdAt: DateTime.now(),
                    id: DateTime.now().toString());
                reqdBuzz.comments.add(newComment);
                ref.read(buzzListProvider.notifier).updateBuzz(reqdBuzz);

                // Make a POST request
                var url =
                    Uri.parse('$server/api/v1/buzzes/${widget.buzzID}/comment');
                final token = ref.read(tokenProvider);
                var response = await http
                    .post(url, body: jsonEncode({"text": content}), headers: {
                  "Content-Type": "application/json",
                  'Authorization': 'Bearer $token',
                });
                if (response.statusCode == 201) {
                  print('Comment posted successfully');
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                } else {
                  print('Failed to post comment');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
