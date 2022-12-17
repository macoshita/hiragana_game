import 'dart:ui';

import 'package:hiragana_game/data/stroke.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final strokesProvider = StateNotifierProvider.family
    .autoDispose<StrokesNotifier, List<Stroke>, int>(
        ((ref, index) => StrokesNotifier()));

class StrokesNotifier extends StateNotifier<List<Stroke>> {
  StrokesNotifier() : super([]);

  void addStroke(Offset firstPoint) {
    state = [
      ...state,
      Stroke(offsets: [firstPoint])
    ];
  }

  void updateLastStroke(Offset offset) {
    state = [
      ...state.sublist(0, state.length - 1),
      state.last.copyWithNewOffset(offset),
    ];
  }
}
