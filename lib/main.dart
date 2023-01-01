import 'package:flutter/material.dart';
import 'package:hiragana_game/pages/question_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hiragana Game',
      home: QuestionPage(),
    );
  }
}
