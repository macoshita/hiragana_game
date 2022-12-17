import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as r;
import 'package:hiragana_game/data/stroke.dart';
import 'package:hiragana_game/models/strokes_provider.dart';
import 'package:hiragana_game/widgets/character_canvas.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionPage extends HookConsumerWidget {
  const QuestionPage({super.key});

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
            DecoratedBox(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: const SizedBox(
                width: 300,
                height: 300,
                child: ListenableCharacterCanvas(index: 0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // ignore: unused_result
                ref.refresh(strokesProvider(0).notifier);
                result.value = '...';
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          result.value = await _check(ref.read(strokesProvider(0)));
        },
        tooltip: 'check',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> _check(List<Stroke> strokes) async {
    final modelManager = r.DigitalInkRecognizerModelManager();
    await modelManager.downloadModel('JA');

    final digitalInkRecognizer = r.DigitalInkRecognizer(languageCode: 'JA');

    final rstrokes = strokes.map((s) {
      r.Stroke rs = r.Stroke();
      rs.points = s.offsets
          .map((o) => r.StrokePoint(
              x: o.dx, y: o.dy, t: DateTime.now().millisecondsSinceEpoch))
          .toList();
      return rs;
    }).toList();

    r.Ink ink = r.Ink(); // it contains all of the Stroke
    ink.strokes = rstrokes;

    final List<r.RecognitionCandidate> candidates =
        await digitalInkRecognizer.recognize(ink);

    return candidates.map((c) => c.text).join(',');
  }
}
