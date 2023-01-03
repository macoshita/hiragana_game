import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as r;
import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hiragana_game/models/handwritten_character_provider.dart';
import 'package:hiragana_game/widgets/cell.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rate_limiter/rate_limiter.dart';

final handwrittenCharactersProvider = StateNotifierProvider.family
    .autoDispose<HandwrittenCharacterNotifier, HandwrittenCharacter, int>(
        (_, __) => HandwrittenCharacterNotifier());

class QuestionPage extends HookConsumerWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answer = 'りざーどん';
    final currentIndex = useState(0);
    final correct = useState(false);
    final currentNotifier =
        ref.watch(handwrittenCharactersProvider(currentIndex.value).notifier);
    final c = debounce((HandwrittenCharacter chara) async {
      final res = await _check(chara);
      if (res.contains(answer[currentIndex.value])) {
        if (currentIndex.value == answer.length - 1) {
          correct.value = true;
        } else {
          currentIndex.value++;
        }
      }
    }, const Duration(milliseconds: 500));

    useEffect(() {
      return currentNotifier.addListener((state) {
        c([state]);
      }, fireImmediately: false);
    }, [currentNotifier]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth / 2,
                  maxHeight: constraints.maxHeight / 3,
                ),
                child: Image.asset(
                  'assets/quiz/p006.png',
                  color: Colors.black,
                  colorBlendMode:
                      correct.value ? BlendMode.dst : BlendMode.srcIn,
                ),
              );
            }),
            Row(children: [
              const SizedBox(width: 16),
              ...List.generate(answer.length, (index) {
                Widget cell = const Cell();
                if (index == currentIndex.value && !correct.value) {
                  cell = DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: cell,
                  );
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ProviderScope(
                      overrides: [
                        handwrittenCharacterProvider.overrideWith((ref) =>
                            ref.watch(
                                handwrittenCharactersProvider(index).notifier))
                      ],
                      child: cell,
                    ),
                  ),
                );
              })
            ]),
            const SizedBox(height: 16),
            if (!correct.value) ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = min(
                      constraints.maxWidth / 4 * 3, constraints.maxHeight / 2);
                  return SizedBox.square(
                    dimension: size,
                    child: ProviderScope(
                      key: Key("ListenableCell-$currentIndex"),
                      overrides: [
                        handwrittenCharacterProvider
                            .overrideWith((ref) => currentNotifier)
                      ],
                      child: const ListenableCell(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: currentNotifier.clear,
                child: const Text('Clear'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<List<String>> _check(HandwrittenCharacter chara) async {
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

  return candidates.map((e) => e.text).toList();
}
