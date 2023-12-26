import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_buzz_bytes/providers/buzzes_provider.dart';
import 'package:vit_buzz_bytes/providers/user_id_provider.dart';
import 'package:vit_buzz_bytes/widgets/buzz_container.dart';

class Buzzes extends ConsumerStatefulWidget {
  final String category;
  const Buzzes({super.key, required this.category});

  @override
  ConsumerState<Buzzes> createState() => _BuzzesState();
}

class _BuzzesState extends ConsumerState<Buzzes> {
  @override
  Widget build(BuildContext context) {
    final currBuzzes = ref.watch(buzzListProvider);
    final likedBuzzes = currBuzzes
        .where((element) =>
            element.likes.contains(ref.read(userIdProvider.notifier).state))
        .toList();
    final likedBuzzesIds = likedBuzzes.map((e) => e.id).toList();

    final dislikedBuzzes = currBuzzes
        .where((element) =>
            element.dislikes.contains(ref.read(userIdProvider.notifier).state))
        .toList();
    final dislikedBuzzesIds = dislikedBuzzes.map((e) => e.id).toList();
    final filteredBuzzes = currBuzzes.where((ele) {
      if (widget.category == 'general') {
        return true;
      }
      return widget.category == ele.category;
    }).toList();
    return ListView.builder(
      itemCount: filteredBuzzes.length,
      itemBuilder: (context, index) {
        return BuzzContainer(
          createdBy: (!filteredBuzzes[index].anonymous!)
              ? filteredBuzzes[index].createdBy
              : 'Anonymous',
          text: filteredBuzzes[index].text,
          id: filteredBuzzes[index].id,
          likes: filteredBuzzes[index].likes,
          dislikes: filteredBuzzes[index].dislikes,
          comments: filteredBuzzes[index].comments,
          isLiked: likedBuzzesIds.contains(filteredBuzzes[index].id),
          isDisliked: dislikedBuzzesIds.contains(filteredBuzzes[index].id),
        );
      },
    );
  }
}
