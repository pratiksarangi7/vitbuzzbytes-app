import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vit_buzz_bytes/widgets/comment_widget.dart';

class CommentsArea extends StatelessWidget {
  final List<dynamic> comments;
  const CommentsArea({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5, left: 0, right: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Comments",
              style: GoogleFonts.montserrat(fontSize: 26),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(17.0)),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return CommentWidget(comment: comments[index]);
                    })),
          ],
        ));
  }
}
