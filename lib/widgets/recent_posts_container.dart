import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vit_buzz_bytes/constants/server.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/my_buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/token_provider.dart';
import 'package:vit_buzz_bytes/utils/buzz.dart';
import 'package:http/http.dart' as http;

class RecentPostContainer extends ConsumerStatefulWidget {
  final Buzz buzz;
  final Function profileFetcher;
  final bool showDeleteButton;
  const RecentPostContainer(
      {super.key,
      required this.buzz,
      required this.profileFetcher,
      required this.showDeleteButton});

  @override
  ConsumerState<RecentPostContainer> createState() =>
      _RecentPostContainerState();
}

class _RecentPostContainerState extends ConsumerState<RecentPostContainer> {
  int deleteButtonPressCount = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 15,
                  child: Icon(Icons.person,
                      size: 24, color: Theme.of(context).colorScheme.surface),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  widget.buzz.createdBy,
                  style: GoogleFonts.lato(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            widget.showDeleteButton
                ? IconButton(
                    icon: const Icon(Icons.delete,
                        size: 30, color: Colors.redAccent),
                    onPressed: () async {
                      ref
                          .read(buzzListProvider.notifier)
                          .removeBuzz(widget.buzz);
                      ref
                          .read(mybuzzListProvider.notifier)
                          .removeBuzz(widget.buzz);
                      final token = ref.read(tokenProvider);
                      // Make the HTTP DELETE request
                      final response = await http.delete(
                        Uri.parse(
                          '$server/api/v1/buzzes/${widget.buzz.id}',
                        ),
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token',
                        },
                      );

                      // Check the status code of the response
                      if (response.statusCode == 204) {
                        print('Buzz deleted successfully');
                        widget.profileFetcher();
                      } else {
                        print(response.body);
                      }
                    },
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
            width: double.infinity,
            child: Text(widget.buzz.text,
                style: GoogleFonts.mulish(fontSize: 22))),
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
                  size: 22,
                  color: Color.fromRGBO(129, 125, 116, 1),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.buzz.likes.length.toString(),
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromRGBO(129, 125, 116, 1)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.thumb_down,
                  size: 22,
                  color: Color.fromRGBO(129, 125, 116, 1),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.buzz.dislikes.length.toString(),
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromRGBO(129, 125, 116, 1)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.comment,
                  size: 22,
                  color: Color.fromRGBO(129, 125, 116, 1),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.buzz.comments.length.toString(),
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromRGBO(129, 125, 116, 1)),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
