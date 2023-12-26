import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vit_buzz_bytes/utils/comment.dart';

class CommentWidget extends StatelessWidget {
  final BuzzComment comment;
  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
                child: Icon(Icons.person,
                    color: Theme.of(context).colorScheme.surface),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(comment.userID,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 24, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            comment.text,
            style: GoogleFonts.merriweather(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            thickness: 0.4,
            color: Color.fromRGBO(129, 125, 116, 1),
          )
        ]));
  }
}
