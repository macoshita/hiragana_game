// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stroke.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Stroke {
  List<Offset> get offsets => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StrokeCopyWith<Stroke> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrokeCopyWith<$Res> {
  factory $StrokeCopyWith(Stroke value, $Res Function(Stroke) then) =
      _$StrokeCopyWithImpl<$Res, Stroke>;
  @useResult
  $Res call({List<Offset> offsets});
}

/// @nodoc
class _$StrokeCopyWithImpl<$Res, $Val extends Stroke>
    implements $StrokeCopyWith<$Res> {
  _$StrokeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offsets = null,
  }) {
    return _then(_value.copyWith(
      offsets: null == offsets
          ? _value.offsets
          : offsets // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StrokeCopyWith<$Res> implements $StrokeCopyWith<$Res> {
  factory _$$_StrokeCopyWith(_$_Stroke value, $Res Function(_$_Stroke) then) =
      __$$_StrokeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Offset> offsets});
}

/// @nodoc
class __$$_StrokeCopyWithImpl<$Res>
    extends _$StrokeCopyWithImpl<$Res, _$_Stroke>
    implements _$$_StrokeCopyWith<$Res> {
  __$$_StrokeCopyWithImpl(_$_Stroke _value, $Res Function(_$_Stroke) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offsets = null,
  }) {
    return _then(_$_Stroke(
      offsets: null == offsets
          ? _value._offsets
          : offsets // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ));
  }
}

/// @nodoc

class _$_Stroke extends _Stroke {
  const _$_Stroke({required final List<Offset> offsets})
      : _offsets = offsets,
        super._();

  final List<Offset> _offsets;
  @override
  List<Offset> get offsets {
    if (_offsets is EqualUnmodifiableListView) return _offsets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offsets);
  }

  @override
  String toString() {
    return 'Stroke(offsets: $offsets)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Stroke &&
            const DeepCollectionEquality().equals(other._offsets, _offsets));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_offsets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StrokeCopyWith<_$_Stroke> get copyWith =>
      __$$_StrokeCopyWithImpl<_$_Stroke>(this, _$identity);
}

abstract class _Stroke extends Stroke {
  const factory _Stroke({required final List<Offset> offsets}) = _$_Stroke;
  const _Stroke._() : super._();

  @override
  List<Offset> get offsets;
  @override
  @JsonKey(ignore: true)
  _$$_StrokeCopyWith<_$_Stroke> get copyWith =>
      throw _privateConstructorUsedError;
}
