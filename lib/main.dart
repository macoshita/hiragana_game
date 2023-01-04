import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiragana_game/pages/quiz_page.dart';
import 'package:hiragana_game/pages/title_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TitlePage(),
    ),
    GoRoute(
      path: '/quiz/:stage',
      builder: (context, state) =>
          QuizPage(stage: int.parse(state.params["stage"]!)),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hiragana Game',
      routerConfig: _router,
    );
  }
}
