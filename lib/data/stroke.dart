import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stroke.freezed.dart';

@freezed
class Stroke with _$Stroke {
  const Stroke._();
  const factory Stroke({
    required List<Offset> offsets,
  }) = _Stroke;

  Stroke copyWithNewOffset(Offset offset) {
    return copyWith(offsets: [...offsets, offset]);
  }
}
