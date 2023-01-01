import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hiragana_game/models/handwritten_character_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final handwrittenCharacterProvider =
    StateNotifierProvider<HandwrittenCharacterNotifier, HandwrittenCharacter>(
        (_) => throw UnimplementedError());

class ListenableCell extends HookConsumerWidget {
  const ListenableCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(handwrittenCharacterProvider.notifier);

    return Listener(
      onPointerDown: (details) {
        notifier.addStroke(details.localPosition);
      },
      onPointerMove: (details) {
        notifier.addPoint(details.localPosition);
      },
      onPointerUp: (details) {
        notifier.addPoint(details.localPosition);
      },
      child: const Cell(),
    );
  }
}

class Cell extends HookConsumerWidget {
  const Cell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final chara = ref.watch(handwrittenCharacterProvider);

    return CustomPaint(
      painter: _Painter(chara, devicePixelRatio),
    );
  }
}

class _Painter extends CustomPainter {
  final HandwrittenCharacter character;
  final double pixelSize;

  _Painter(this.character, double devicePixelRatio)
      : pixelSize = 1 / devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1);
    canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1);

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;
    for (final stroke in character) {
      canvas.drawPoints(PointMode.polygon, stroke, paint);
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return !const DeepCollectionEquality()
        .equals(character, oldDelegate.character);
  }
}
