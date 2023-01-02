import 'dart:ui';

import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as r;
import 'package:hiragana_game/data/handwritten_character.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HandwrittenCharacterNotifier extends StateNotifier<HandwrittenCharacter> {
  HandwrittenCharacterNotifier() : super([]);

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

  Future<List<String>> check() async {
    final modelManager = r.DigitalInkRecognizerModelManager();
    await modelManager.downloadModel('JA');

    final digitalInkRecognizer = r.DigitalInkRecognizer(languageCode: 'JA');

    final strokes = state.map((s) {
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
}
