// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'result_card_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ResultCardStateTearOff {
  const _$ResultCardStateTearOff();

  _ResultCardState call(
      {bool isComplete = false,
      ProcessHtmlResult? result,
      List<String> paragraphs = const [],
      List<String> images = const [],
      PaletteGenerator? paletteGenerator}) {
    return _ResultCardState(
      isComplete: isComplete,
      result: result,
      paragraphs: paragraphs,
      images: images,
      paletteGenerator: paletteGenerator,
    );
  }
}

/// @nodoc
const $ResultCardState = _$ResultCardStateTearOff();

/// @nodoc
mixin _$ResultCardState {
  bool get isComplete => throw _privateConstructorUsedError;
  ProcessHtmlResult? get result => throw _privateConstructorUsedError;
  List<String> get paragraphs => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  PaletteGenerator? get paletteGenerator => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResultCardStateCopyWith<ResultCardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCardStateCopyWith<$Res> {
  factory $ResultCardStateCopyWith(
          ResultCardState value, $Res Function(ResultCardState) then) =
      _$ResultCardStateCopyWithImpl<$Res>;
  $Res call(
      {bool isComplete,
      ProcessHtmlResult? result,
      List<String> paragraphs,
      List<String> images,
      PaletteGenerator? paletteGenerator});
}

/// @nodoc
class _$ResultCardStateCopyWithImpl<$Res>
    implements $ResultCardStateCopyWith<$Res> {
  _$ResultCardStateCopyWithImpl(this._value, this._then);

  final ResultCardState _value;
  // ignore: unused_field
  final $Res Function(ResultCardState) _then;

  @override
  $Res call({
    Object? isComplete = freezed,
    Object? result = freezed,
    Object? paragraphs = freezed,
    Object? images = freezed,
    Object? paletteGenerator = freezed,
  }) {
    return _then(_value.copyWith(
      isComplete: isComplete == freezed
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ProcessHtmlResult?,
      paragraphs: paragraphs == freezed
          ? _value.paragraphs
          : paragraphs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: images == freezed
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      paletteGenerator: paletteGenerator == freezed
          ? _value.paletteGenerator
          : paletteGenerator // ignore: cast_nullable_to_non_nullable
              as PaletteGenerator?,
    ));
  }
}

/// @nodoc
abstract class _$ResultCardStateCopyWith<$Res>
    implements $ResultCardStateCopyWith<$Res> {
  factory _$ResultCardStateCopyWith(
          _ResultCardState value, $Res Function(_ResultCardState) then) =
      __$ResultCardStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isComplete,
      ProcessHtmlResult? result,
      List<String> paragraphs,
      List<String> images,
      PaletteGenerator? paletteGenerator});
}

/// @nodoc
class __$ResultCardStateCopyWithImpl<$Res>
    extends _$ResultCardStateCopyWithImpl<$Res>
    implements _$ResultCardStateCopyWith<$Res> {
  __$ResultCardStateCopyWithImpl(
      _ResultCardState _value, $Res Function(_ResultCardState) _then)
      : super(_value, (v) => _then(v as _ResultCardState));

  @override
  _ResultCardState get _value => super._value as _ResultCardState;

  @override
  $Res call({
    Object? isComplete = freezed,
    Object? result = freezed,
    Object? paragraphs = freezed,
    Object? images = freezed,
    Object? paletteGenerator = freezed,
  }) {
    return _then(_ResultCardState(
      isComplete: isComplete == freezed
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ProcessHtmlResult?,
      paragraphs: paragraphs == freezed
          ? _value.paragraphs
          : paragraphs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: images == freezed
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      paletteGenerator: paletteGenerator == freezed
          ? _value.paletteGenerator
          : paletteGenerator // ignore: cast_nullable_to_non_nullable
              as PaletteGenerator?,
    ));
  }
}

/// @nodoc

class _$_ResultCardState extends _ResultCardState {
  const _$_ResultCardState(
      {this.isComplete = false,
      this.result,
      this.paragraphs = const [],
      this.images = const [],
      this.paletteGenerator})
      : super._();

  @JsonKey(defaultValue: false)
  @override
  final bool isComplete;
  @override
  final ProcessHtmlResult? result;
  @JsonKey(defaultValue: const [])
  @override
  final List<String> paragraphs;
  @JsonKey(defaultValue: const [])
  @override
  final List<String> images;
  @override
  final PaletteGenerator? paletteGenerator;

  @override
  String toString() {
    return 'ResultCardState(isComplete: $isComplete, result: $result, paragraphs: $paragraphs, images: $images, paletteGenerator: $paletteGenerator)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResultCardState &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality()
                .equals(other.paragraphs, paragraphs) &&
            const DeepCollectionEquality().equals(other.images, images) &&
            (identical(other.paletteGenerator, paletteGenerator) ||
                other.paletteGenerator == paletteGenerator));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isComplete,
      result,
      const DeepCollectionEquality().hash(paragraphs),
      const DeepCollectionEquality().hash(images),
      paletteGenerator);

  @JsonKey(ignore: true)
  @override
  _$ResultCardStateCopyWith<_ResultCardState> get copyWith =>
      __$ResultCardStateCopyWithImpl<_ResultCardState>(this, _$identity);
}

abstract class _ResultCardState extends ResultCardState {
  const factory _ResultCardState(
      {bool isComplete,
      ProcessHtmlResult? result,
      List<String> paragraphs,
      List<String> images,
      PaletteGenerator? paletteGenerator}) = _$_ResultCardState;
  const _ResultCardState._() : super._();

  @override
  bool get isComplete;
  @override
  ProcessHtmlResult? get result;
  @override
  List<String> get paragraphs;
  @override
  List<String> get images;
  @override
  PaletteGenerator? get paletteGenerator;
  @override
  @JsonKey(ignore: true)
  _$ResultCardStateCopyWith<_ResultCardState> get copyWith =>
      throw _privateConstructorUsedError;
}
