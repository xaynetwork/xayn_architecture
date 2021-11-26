// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'navigator_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NavigatorStateTearOff {
  const _$NavigatorStateTearOff();

  _NavigatorState call({required List<PageData> pages}) {
    return _NavigatorState(
      pages: pages,
    );
  }
}

/// @nodoc
const $NavigatorState = _$NavigatorStateTearOff();

/// @nodoc
mixin _$NavigatorState {
  List<PageData> get pages => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NavigatorStateCopyWith<NavigatorState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavigatorStateCopyWith<$Res> {
  factory $NavigatorStateCopyWith(
          NavigatorState value, $Res Function(NavigatorState) then) =
      _$NavigatorStateCopyWithImpl<$Res>;
  $Res call({List<PageData> pages});
}

/// @nodoc
class _$NavigatorStateCopyWithImpl<$Res>
    implements $NavigatorStateCopyWith<$Res> {
  _$NavigatorStateCopyWithImpl(this._value, this._then);

  final NavigatorState _value;
  // ignore: unused_field
  final $Res Function(NavigatorState) _then;

  @override
  $Res call({
    Object? pages = freezed,
  }) {
    return _then(_value.copyWith(
      pages: pages == freezed
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PageData>,
    ));
  }
}

/// @nodoc
abstract class _$NavigatorStateCopyWith<$Res>
    implements $NavigatorStateCopyWith<$Res> {
  factory _$NavigatorStateCopyWith(
          _NavigatorState value, $Res Function(_NavigatorState) then) =
      __$NavigatorStateCopyWithImpl<$Res>;
  @override
  $Res call({List<PageData> pages});
}

/// @nodoc
class __$NavigatorStateCopyWithImpl<$Res>
    extends _$NavigatorStateCopyWithImpl<$Res>
    implements _$NavigatorStateCopyWith<$Res> {
  __$NavigatorStateCopyWithImpl(
      _NavigatorState _value, $Res Function(_NavigatorState) _then)
      : super(_value, (v) => _then(v as _NavigatorState));

  @override
  _NavigatorState get _value => super._value as _NavigatorState;

  @override
  $Res call({
    Object? pages = freezed,
  }) {
    return _then(_NavigatorState(
      pages: pages == freezed
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PageData>,
    ));
  }
}

/// @nodoc

class _$_NavigatorState extends _NavigatorState {
  _$_NavigatorState({required this.pages}) : super._();

  @override
  final List<PageData> pages;

  @override
  String toString() {
    return 'NavigatorState(pages: $pages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavigatorState &&
            const DeepCollectionEquality().equals(other.pages, pages));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(pages));

  @JsonKey(ignore: true)
  @override
  _$NavigatorStateCopyWith<_NavigatorState> get copyWith =>
      __$NavigatorStateCopyWithImpl<_NavigatorState>(this, _$identity);
}

abstract class _NavigatorState extends NavigatorState {
  factory _NavigatorState({required List<PageData> pages}) = _$_NavigatorState;
  _NavigatorState._() : super._();

  @override
  List<PageData> get pages;
  @override
  @JsonKey(ignore: true)
  _$NavigatorStateCopyWith<_NavigatorState> get copyWith =>
      throw _privateConstructorUsedError;
}
