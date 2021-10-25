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

  _ScreenState call({User? user, int? position, bool? hasError}) {
    return _ScreenState(
      user: user,
      position: position,
      hasError: hasError,
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
  User? get user => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  bool? get hasError => throw _privateConstructorUsedError;

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
  $Res call({User? user, int? position, bool? hasError});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$ScreenStateCopyWithImpl<$Res> implements $ScreenStateCopyWith<$Res> {
  _$ScreenStateCopyWithImpl(this._value, this._then);

  final ScreenState _value;
  // ignore: unused_field
  final $Res Function(ScreenState) _then;

  @override
  $Res call({
    Object? user = freezed,
    Object? position = freezed,
    Object? hasError = freezed,
  }) {
    return _then(_value.copyWith(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      hasError: hasError == freezed
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  @override
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
abstract class _$ScreenStateCopyWith<$Res>
    implements $ScreenStateCopyWith<$Res> {
  factory _$ScreenStateCopyWith(
          _ScreenState value, $Res Function(_ScreenState) then) =
      __$ScreenStateCopyWithImpl<$Res>;
  @override
  $Res call({User? user, int? position, bool? hasError});

  @override
  $UserCopyWith<$Res>? get user;
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
    Object? user = freezed,
    Object? position = freezed,
    Object? hasError = freezed,
  }) {
    return _then(_ScreenState(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      hasError: hasError == freezed
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ScreenState extends _ScreenState with DiagnosticableTreeMixin {
  const _$_ScreenState({this.user, this.position, this.hasError}) : super._();

  factory _$_ScreenState.fromJson(Map<String, dynamic> json) =>
      _$$_ScreenStateFromJson(json);

  @override
  final User? user;
  @override
  final int? position;
  @override
  final bool? hasError;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScreenState(user: $user, position: $position, hasError: $hasError)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScreenState'))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('hasError', hasError));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScreenState &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, position, hasError);

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
  const factory _ScreenState({User? user, int? position, bool? hasError}) =
      _$_ScreenState;
  const _ScreenState._() : super._();

  factory _ScreenState.fromJson(Map<String, dynamic> json) =
      _$_ScreenState.fromJson;

  @override
  User? get user;
  @override
  int? get position;
  @override
  bool? get hasError;
  @override
  @JsonKey(ignore: true)
  _$ScreenStateCopyWith<_ScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}
