import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_buzz_bytes/utils/buzz.dart';

final buzzListProvider = StateNotifierProvider<BuzzListNotifier, List<Buzz>>(
    (ref) => BuzzListNotifier());

class BuzzListNotifier extends StateNotifier<List<Buzz>> {
  BuzzListNotifier() : super([]);
  List<Buzz> get currentState => state;
  void removeBuzz(Buzz buzz) {
    state = state.where((b) => b.id != buzz.id).toList();
  }

  void updateBuzz(Buzz updatedBuzz) {
    state = [
      for (final buzz in state)
        if (buzz.id == updatedBuzz.id) updatedBuzz else buzz,
    ];
  }
}
