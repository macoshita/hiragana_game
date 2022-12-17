import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hiragana_game/data/stroke.dart';
import 'package:hiragana_game/models/strokes_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListenableCharacterCanvas extends HookConsumerWidget {
  final int index;

  const ListenableCharacterCanvas({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(strokesProvider(index).notifier);

    return Listener(
      onPointerDown: (details) {
        notifier.addStroke(details.localPosition);
      },
      onPointerMove: (details) {
        notifier.updateLastStroke(details.localPosition);
      },
      onPointerUp: (details) {
        notifier.updateLastStroke(details.localPosition);
      },
      child: CharacterCanvas(index: index),
    );
  }
}

class CharacterCanvas extends HookConsumerWidget {
  final int index;

  const CharacterCanvas({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strokes = ref.watch(strokesProvider(index));

    return CustomPaint(
      painter: _Painter(strokes),
    );
  }
}

class _Painter extends CustomPainter {
  final List<Stroke> strokes;

  _Painter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    for (var stroke in strokes) {
      canvas.drawPoints(PointMode.polygon, stroke.offsets, paint);
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return !const DeepCollectionEquality().equals(strokes, oldDelegate.strokes);
  }
}
