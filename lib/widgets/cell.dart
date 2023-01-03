import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hiragana_game/models/handwritten_character_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final handwrittenCharacterProvider = StateNotifierProvider.autoDispose<
    HandwrittenCharacterNotifier,
    HandwrittenCharacter>((_) => throw UnimplementedError());

class ListenableCell extends HookConsumerWidget {
  const ListenableCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(handwrittenCharacterProvider.notifier);

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(builder: (context, constraints) {
        return Listener(
          onPointerDown: (details) {
            notifier.addStroke(
                details.localPosition.normalize(constraints.maxWidth));
          },
          onPointerMove: (details) {
            notifier.addPoint(
                details.localPosition.normalize(constraints.maxWidth));
          },
          onPointerUp: (details) {
            notifier.addPoint(
                details.localPosition.normalize(constraints.maxWidth));
          },
          child: const Cell(),
        );
      }),
    );
  }
}

class Cell extends HookConsumerWidget {
  const Cell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final character = ref.watch(handwrittenCharacterProvider);

    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _Painter(character, devicePixelRatio),
      ),
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
      canvas.drawPoints(
        PointMode.polygon,
        stroke.map((e) => e.denormalize(size.width)).toList(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return !const DeepCollectionEquality()
        .equals(character, oldDelegate.character);
  }
}

const _normalizedSize = 1000.0;

extension _OffsetX on Offset {
  Offset normalize(double size) {
    final s = _normalizedSize / size;
    return scale(s, s);
  }

  Offset denormalize(double size) {
    final s = size / _normalizedSize;
    return scale(s, s);
  }
}
