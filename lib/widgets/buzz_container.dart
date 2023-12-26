import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/pages/comments_screen.dart';
import 'package:vit_buzz_bytes/pages/other_profile.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:vit_buzz_bytes/providers/user_id_provider.dart';
import 'package:http/http.dart' as http;

class BuzzContainer extends ConsumerStatefulWidget {
  final String createdBy;
  final String text;
  final String id;
  final String? image;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final List<dynamic> comments;
  final bool isLiked;
  final bool isDisliked;

  const BuzzContainer(
      {super.key,
      required this.createdBy,
      required this.text,
      required this.id,
      this.image,
      required this.likes,
      required this.dislikes,
      required this.comments,
      required this.isLiked,
      required this.isDisliked});

  @override
  ConsumerState<BuzzContainer> createState() => _BuzzContainerState();
}

class _BuzzContainerState extends ConsumerState<BuzzContainer> {
  Future<void> likeDislike(String action, String id) async {
    final buzzes = ref.read(buzzListProvider.notifier).currentState;
    final buzz = buzzes.firstWhere((buzz) => buzz.id == id);
    final user = ref.read(userIdProvider.notifier).state;
    final url = "$server/api/v1/buzzes/$id/$action";
    final token = ref.read(tokenProvider.notifier).state;
    if (action == 'like') {
      // if user has already disliked the buzz, remove the dislike
      if (buzz.dislikes.contains(user) && !buzz.likes.contains(user)) {
        buzz.dislikes.remove(user);
        ref.read(buzzListProvider.notifier).updateBuzz(buzz);
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update buzz');
        }
      }
      if (!buzz.likes.contains(user)) {
        buzz.likes.add(user);
        ref.read(buzzListProvider.notifier).updateBuzz(buzz);
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'like': true}),
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update buzz');
        }
      } else {
        buzz.likes.remove(user);
        ref.read(buzzListProvider.notifier).updateBuzz(buzz);

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update buzz');
        }
      }
    }
    if (action == 'dislike') {
      // if user has already liked the buzz, remove the like
      if (buzz.likes.contains(user) && !buzz.dislikes.contains(user)) {
        buzz.likes.remove(user);
        ref.read(buzzListProvider.notifier).updateBuzz(buzz);
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update buzz');
        }
      }
      if (!buzz.dislikes.contains(user)) {
        buzz.dislikes.add(user);
        ref.read(buzzListProvider.notifier).updateBuzz(buzz);
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'dislike': true}),
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update buzz');
        }
      } else {
        buzz.dislikes.remove(user);
        ref.read(buzzListProvider.notifier).updateBuzz(buzz);

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update buzz');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 16, bottom: 7, top: 15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        OtherProfilePage(
                      userId: widget.createdBy,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 15,
                    child: Icon(Icons.person,
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.createdBy,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 19)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: widget.isLiked
                            ? Colors.amber[600]
                            : const Color.fromRGBO(129, 125, 116, 1),
                      ),
                      iconSize: 24,
                      onPressed: () async {
                        await likeDislike('like', widget.id);
                      },
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.likes.length.toString(),
                      style: TextStyle(
                          fontSize: 21,
                          color: widget.isLiked
                              ? Colors.amber[600]
                              : const Color.fromRGBO(129, 125, 116, 1)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: widget.isDisliked
                            ? Colors.amber[600]
                            : const Color.fromRGBO(129, 125, 116, 1),
                      ),
                      iconSize: 24,
                      onPressed: () async {
                        await likeDislike('dislike', widget.id);
                      },
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.dislikes.length.toString(),
                      style: TextStyle(
                          fontSize: 21,
                          color: widget.isDisliked
                              ? Colors.amber[600]
                              : const Color.fromRGBO(129, 125, 116, 1)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.comment,
                        color: Color.fromRGBO(129, 125, 116, 1),
                      ),
                      iconSize: 24,
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CommentsScreen(buzzID: widget.id),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(0.0, 1.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.comments.length.toString(),
                      style: const TextStyle(
                          fontSize: 21,
                          color: Color.fromRGBO(129, 125, 116, 1)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
