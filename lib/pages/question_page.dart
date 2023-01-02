import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
                  child: ListenableCell(
                    onCheck: (res, _) {
                      result.value = res.join(',');
                    },
                  ),
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
    );
  }
}
