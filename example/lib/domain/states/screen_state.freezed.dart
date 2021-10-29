// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ScreenState _$ScreenStateFromJson(Map<String, dynamic> json) {
  return _ScreenState.fromJson(json);
}

/// @nodoc
class _$ScreenStateTearOff {
  const _$ScreenStateTearOff();

  _ScreenState call(
      {List<Document>? results,
      required int resultIndex,
      required bool isComplete}) {
    return _ScreenState(
      results: results,
      resultIndex: resultIndex,
      isComplete: isComplete,
    );
  }

  ScreenState fromJson(Map<String, Object?> json) {
    return ScreenState.fromJson(json);
  }
}

/// @nodoc
const $ScreenState = _$ScreenStateTearOff();

/// @nodoc
mixin _$ScreenState {
  List<Document>? get results => throw _privateConstructorUsedError;
  int get resultIndex => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScreenStateCopyWith<ScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenStateCopyWith<$Res> {
  factory $ScreenStateCopyWith(
          ScreenState value, $Res Function(ScreenState) then) =
      _$ScreenStateCopyWithImpl<$Res>;
  $Res call({List<Document>? results, int resultIndex, bool isComplete});
}

/// @nodoc
class _$ScreenStateCopyWithImpl<$Res> implements $ScreenStateCopyWith<$Res> {
  _$ScreenStateCopyWithImpl(this._value, this._then);

  final ScreenState _value;
  // ignore: unused_field
  final $Res Function(ScreenState) _then;

  @override
  $Res call({
    Object? results = freezed,
    Object? resultIndex = freezed,
    Object? isComplete = freezed,
  }) {
    return _then(_value.copyWith(
      results: results == freezed
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Document>?,
      resultIndex: resultIndex == freezed
          ? _value.resultIndex
          : resultIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isComplete: isComplete == freezed
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ScreenStateCopyWith<$Res>
    implements $ScreenStateCopyWith<$Res> {
  factory _$ScreenStateCopyWith(
          _ScreenState value, $Res Function(_ScreenState) then) =
      __$ScreenStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Document>? results, int resultIndex, bool isComplete});
}

/// @nodoc
class __$ScreenStateCopyWithImpl<$Res> extends _$ScreenStateCopyWithImpl<$Res>
    implements _$ScreenStateCopyWith<$Res> {
  __$ScreenStateCopyWithImpl(
      _ScreenState _value, $Res Function(_ScreenState) _then)
      : super(_value, (v) => _then(v as _ScreenState));

  @override
  _ScreenState get _value => super._value as _ScreenState;

  @override
  $Res call({
    Object? results = freezed,
    Object? resultIndex = freezed,
    Object? isComplete = freezed,
  }) {
    return _then(_ScreenState(
      results: results == freezed
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Document>?,
      resultIndex: resultIndex == freezed
          ? _value.resultIndex
          : resultIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isComplete: isComplete == freezed
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ScreenState extends _ScreenState with DiagnosticableTreeMixin {
  const _$_ScreenState(
      {this.results, required this.resultIndex, required this.isComplete})
      : super._();

  factory _$_ScreenState.fromJson(Map<String, dynamic> json) =>
      _$$_ScreenStateFromJson(json);

  @override
  final List<Document>? results;
  @override
  final int resultIndex;
  @override
  final bool isComplete;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScreenState(results: $results, resultIndex: $resultIndex, isComplete: $isComplete)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScreenState'))
      ..add(DiagnosticsProperty('results', results))
      ..add(DiagnosticsProperty('resultIndex', resultIndex))
      ..add(DiagnosticsProperty('isComplete', isComplete));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScreenState &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.resultIndex, resultIndex) ||
                other.resultIndex == resultIndex) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(results), resultIndex, isComplete);

  @JsonKey(ignore: true)
  @override
  _$ScreenStateCopyWith<_ScreenState> get copyWith =>
      __$ScreenStateCopyWithImpl<_ScreenState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScreenStateToJson(this);
  }
}

abstract class _ScreenState extends ScreenState {
  const factory _ScreenState(
      {List<Document>? results,
      required int resultIndex,
      required bool isComplete}) = _$_ScreenState;
  const _ScreenState._() : super._();

  factory _ScreenState.fromJson(Map<String, dynamic> json) =
      _$_ScreenState.fromJson;

  @override
  List<Document>? get results;
  @override
  int get resultIndex;
  @override
  bool get isComplete;
  @override
  @JsonKey(ignore: true)
  _$ScreenStateCopyWith<_ScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

ScreenErrorState _$ScreenErrorStateFromJson(Map<String, dynamic> json) {
  return _ScreenErrorState.fromJson(json);
}

/// @nodoc
class _$ScreenErrorStateTearOff {
  const _$ScreenErrorStateTearOff();

  _ScreenErrorState call() {
    return const _ScreenErrorState();
  }

  ScreenErrorState fromJson(Map<String, Object?> json) {
    return ScreenErrorState.fromJson(json);
  }
}

/// @nodoc
const $ScreenErrorState = _$ScreenErrorStateTearOff();

/// @nodoc
mixin _$ScreenErrorState {
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenErrorStateCopyWith<$Res> {
  factory $ScreenErrorStateCopyWith(
          ScreenErrorState value, $Res Function(ScreenErrorState) then) =
      _$ScreenErrorStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ScreenErrorStateCopyWithImpl<$Res>
    implements $ScreenErrorStateCopyWith<$Res> {
  _$ScreenErrorStateCopyWithImpl(this._value, this._then);

  final ScreenErrorState _value;
  // ignore: unused_field
  final $Res Function(ScreenErrorState) _then;
}

/// @nodoc
abstract class _$ScreenErrorStateCopyWith<$Res> {
  factory _$ScreenErrorStateCopyWith(
          _ScreenErrorState value, $Res Function(_ScreenErrorState) then) =
      __$ScreenErrorStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$ScreenErrorStateCopyWithImpl<$Res>
    extends _$ScreenErrorStateCopyWithImpl<$Res>
    implements _$ScreenErrorStateCopyWith<$Res> {
  __$ScreenErrorStateCopyWithImpl(
      _ScreenErrorState _value, $Res Function(_ScreenErrorState) _then)
      : super(_value, (v) => _then(v as _ScreenErrorState));

  @override
  _ScreenErrorState get _value => super._value as _ScreenErrorState;
}

/// @nodoc
@JsonSerializable()
class _$_ScreenErrorState extends _ScreenErrorState
    with DiagnosticableTreeMixin {
  const _$_ScreenErrorState() : super._();

  factory _$_ScreenErrorState.fromJson(Map<String, dynamic> json) =>
      _$$_ScreenErrorStateFromJson(json);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScreenErrorState()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ScreenErrorState'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ScreenErrorState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScreenErrorStateToJson(this);
  }
}

abstract class _ScreenErrorState extends ScreenErrorState {
  const factory _ScreenErrorState() = _$_ScreenErrorState;
  const _ScreenErrorState._() : super._();

  factory _ScreenErrorState.fromJson(Map<String, dynamic> json) =
      _$_ScreenErrorState.fromJson;
}
