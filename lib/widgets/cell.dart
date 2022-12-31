import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hiragana_game/models/strokes_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final strokesProvider =
    StateNotifierProvider.autoDispose<StrokesNotifier, HandwrittenCharacter>(
        (_) => StrokesNotifier());

class ListenableCell extends HookConsumerWidget {
  const ListenableCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(strokesProvider.notifier);

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
    final strokes = ref.watch(strokesProvider);

    return CustomPaint(
      painter: _Painter(strokes, devicePixelRatio),
    );
  }
}

class _Painter extends CustomPainter {
  final List<HandwrittenStroke> strokes;
  final double pixelSize;

  _Painter(this.strokes, double devicePixelRatio)
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
      ..strokeWidth = 3;
    for (final stroke in strokes) {
      canvas.drawPoints(PointMode.polygon, stroke, paint);
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return !const DeepCollectionEquality().equals(strokes, oldDelegate.strokes);
  }
}
