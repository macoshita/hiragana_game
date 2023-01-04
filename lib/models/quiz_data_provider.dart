import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizDataProvider =
    StateNotifierProvider<QuizDataNotifier, AsyncValue<List<QuizData>>>(
        (ref) => QuizDataNotifier());

class QuizData extends Equatable {
  final String hiragana;
  final String image;

  const QuizData({required this.hiragana, required this.image});

  @override
  List<Object?> get props => [hiragana, image];

  QuizData.fromJson(Map<String, dynamic> json)
      : hiragana = json['hiragana'],
        image = json['image'];
}

class QuizDataNotifier extends StateNotifier<AsyncValue<List<QuizData>>> {
  QuizDataNotifier() : super(const AsyncLoading());

  List<QuizData>? _allData;

  Future<void> shuffle(AssetBundle assetBundle) async {
    state = await AsyncValue.guard(() async {
      _allData ??= await assetBundle.loadStructuredData(
        "assets/quiz/data.json",
        (value) async {
          final List json = jsonDecode(value);
          return json.map((d) => QuizData.fromJson(d)).toList();
        },
      );

      // TODO: shuffle
      return _allData!;
    });
  }
}
