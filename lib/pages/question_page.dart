import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as r;
import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hiragana_game/models/handwritten_character_provider.dart';
import 'package:hiragana_game/widgets/cell.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionPage extends HookConsumerWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        handwrittenCharacterProvider
            .overrideWith((ref) => HandwrittenCharacterNotifier()),
      ],
      child: const _Page(),
    );
  }
}

class _Page extends HookConsumerWidget {
  const _Page();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = useState('...');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              result.value,
              style: const TextStyle(fontSize: 20),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final size = min(
                    constraints.maxWidth / 4 * 3, constraints.maxHeight / 2);
                return SizedBox.square(
                  dimension: size,
                  child: const ListenableCell(),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                ref.refresh(handwrittenCharacterProvider.notifier);
                result.value = '...';
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          result.value = await _check(ref.read(handwrittenCharacterProvider));
        },
        tooltip: 'check',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String> _check(HandwrittenCharacter chara) async {
    final modelManager = r.DigitalInkRecognizerModelManager();
    await modelManager.downloadModel('JA');

    final digitalInkRecognizer = r.DigitalInkRecognizer(languageCode: 'JA');

    final strokes = chara.map((s) {
      r.Stroke rs = r.Stroke();
      rs.points =
          s.map((o) => r.StrokePoint(x: o.dx, y: o.dy, t: o.time)).toList();
      return rs;
    }).toList();

    r.Ink ink = r.Ink(); // it contains all of the Stroke
    ink.strokes = strokes;

    final List<r.RecognitionCandidate> candidates =
        await digitalInkRecognizer.recognize(ink);

    return candidates.map((c) => c.text).join(',');
  }
}
