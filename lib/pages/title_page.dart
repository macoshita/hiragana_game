import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hiragana_game/models/quiz_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TitlePage extends HookConsumerWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizData = ref.watch(quizDataProvider);
    final assetBundle = DefaultAssetBundle.of(context);
    useEffect(() {
      ref.read(quizDataProvider.notifier).shuffle(assetBundle);
      return;
    }, [assetBundle]);

    if (quizData.isLoading) {
      return const Scaffold(
        body: Center(
          child: Text('よみこみちゅう……'),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "しるえっとくいず",
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go("/quiz/0");
              },
              child: const Text("すたーと"),
            ),
          ],
        ),
      ),
    );
  }
}
