import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class HandwrittenPoint extends Offset with EquatableMixin {
  final int time;

  const HandwrittenPoint(super.dx, super.dy, this.time);

  @override
  List<Object?> get props => [dx, dy, time];

  static HandwrittenPoint fromOffset(Offset offset) => HandwrittenPoint(
        offset.dx,
        offset.dy,
        DateTime.now().millisecondsSinceEpoch,
      );
}

typedef HandwrittenStroke = List<HandwrittenPoint>;
typedef HandwrittenCharacter = List<HandwrittenStroke>;
