import 'dart:ui';

import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StrokesNotifier extends StateNotifier<HandwrittenCharacter> {
  StrokesNotifier() : super([]);

  void addStroke(Offset offset) {
    state = [
      ...state,
      [HandwrittenPoint.fromOffset(offset)]
    ];
  }

  void addPoint(Offset offset) {
    state = [
      ...state.sublist(0, state.length - 1),
      [...state.last, HandwrittenPoint.fromOffset(offset)]
    ];
  }
}
