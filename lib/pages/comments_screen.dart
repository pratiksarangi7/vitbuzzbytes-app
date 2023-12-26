import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/widgets/add_comment.dart';
import 'package:vit_buzz_bytes/widgets/comments_area.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String buzzID;
  const CommentsScreen({super.key, required this.buzzID});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final currBuzzes = ref.watch(buzzListProvider);
    final selectedBuzz =
        currBuzzes.firstWhere((element) => element.id == widget.buzzID);
    return Scaffold(
        appBar: AppBar(
            title:
                Text("Buzz", style: Theme.of(context).textTheme.displayMedium)),
        body: Padding(
          padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17.0),
                    topRight: Radius.circular(17.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 22,
                          child: Icon(Icons.person,
                              size: 36,
                              color: Theme.of(context).colorScheme.surface),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectedBuzz.createdBy,
                          style: GoogleFonts.lato(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(selectedBuzz.text,
                        style: GoogleFonts.mulish(fontSize: 24)),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_up,
                              size: 30,
                              color: Color.fromRGBO(129, 125, 116, 1),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedBuzz.likes.length.toString(),
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(129, 125, 116, 1)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_down,
                              size: 30,
                              color: Color.fromRGBO(129, 125, 116, 1),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedBuzz.dislikes.length.toString(),
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(129, 125, 116, 1)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.comment,
                              size: 30,
                              color: Colors.amber[400],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedBuzz.comments.length.toString(),
                              style: TextStyle(
                                  fontSize: 25, color: Colors.amber[400]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AddComment(buzzID: widget.buzzID),
                    const SizedBox(
                      height: 7,
                    ),
                    const Divider(color: Color.fromRGBO(129, 125, 116, 1)),
                    const SizedBox(
                      height: 7,
                    ),
                    CommentsArea(
                      comments: selectedBuzz.comments,
                    )
                  ],
                )),
          ),
        ));
  }
}
