// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'page_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PageDataTearOff {
  const _$PageDataTearOff();

  _PageData<T> call<T extends Widget>(
      {required String name,
      bool isInitial = false,
      required PageBuilder builder,
      Completer<dynamic>? pendingResult,
      dynamic? arguments}) {
    return _PageData<T>(
      name: name,
      isInitial: isInitial,
      builder: builder,
      pendingResult: pendingResult,
      arguments: arguments,
    );
  }
}

/// @nodoc
const $PageData = _$PageDataTearOff();

/// @nodoc
mixin _$PageData<T extends Widget> {
  String get name => throw _privateConstructorUsedError;
  bool get isInitial => throw _privateConstructorUsedError;
  PageBuilder get builder => throw _privateConstructorUsedError;
  Completer<dynamic>? get pendingResult => throw _privateConstructorUsedError;
  dynamic? get arguments => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PageDataCopyWith<T, PageData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageDataCopyWith<T extends Widget, $Res> {
  factory $PageDataCopyWith(
          PageData<T> value, $Res Function(PageData<T>) then) =
      _$PageDataCopyWithImpl<T, $Res>;
  $Res call(
      {String name,
      bool isInitial,
      PageBuilder builder,
      Completer<dynamic>? pendingResult,
      dynamic? arguments});
}

/// @nodoc
class _$PageDataCopyWithImpl<T extends Widget, $Res>
    implements $PageDataCopyWith<T, $Res> {
  _$PageDataCopyWithImpl(this._value, this._then);

  final PageData<T> _value;
  // ignore: unused_field
  final $Res Function(PageData<T>) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? isInitial = freezed,
    Object? builder = freezed,
    Object? pendingResult = freezed,
    Object? arguments = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isInitial: isInitial == freezed
          ? _value.isInitial
          : isInitial // ignore: cast_nullable_to_non_nullable
              as bool,
      builder: builder == freezed
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as PageBuilder,
      pendingResult: pendingResult == freezed
          ? _value.pendingResult
          : pendingResult // ignore: cast_nullable_to_non_nullable
              as Completer<dynamic>?,
      arguments: arguments == freezed
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as dynamic?,
    ));
  }
}

/// @nodoc
abstract class _$PageDataCopyWith<T extends Widget, $Res>
    implements $PageDataCopyWith<T, $Res> {
  factory _$PageDataCopyWith(
          _PageData<T> value, $Res Function(_PageData<T>) then) =
      __$PageDataCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {String name,
      bool isInitial,
      PageBuilder builder,
      Completer<dynamic>? pendingResult,
      dynamic? arguments});
}

/// @nodoc
class __$PageDataCopyWithImpl<T extends Widget, $Res>
    extends _$PageDataCopyWithImpl<T, $Res>
    implements _$PageDataCopyWith<T, $Res> {
  __$PageDataCopyWithImpl(
      _PageData<T> _value, $Res Function(_PageData<T>) _then)
      : super(_value, (v) => _then(v as _PageData<T>));

  @override
  _PageData<T> get _value => super._value as _PageData<T>;

  @override
  $Res call({
    Object? name = freezed,
    Object? isInitial = freezed,
    Object? builder = freezed,
    Object? pendingResult = freezed,
    Object? arguments = freezed,
  }) {
    return _then(_PageData<T>(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isInitial: isInitial == freezed
          ? _value.isInitial
          : isInitial // ignore: cast_nullable_to_non_nullable
              as bool,
      builder: builder == freezed
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as PageBuilder,
      pendingResult: pendingResult == freezed
          ? _value.pendingResult
          : pendingResult // ignore: cast_nullable_to_non_nullable
              as Completer<dynamic>?,
      arguments: arguments == freezed
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as dynamic?,
    ));
  }
}

/// @nodoc

class _$_PageData<T extends Widget> extends _PageData<T> {
  _$_PageData(
      {required this.name,
      this.isInitial = false,
      required this.builder,
      this.pendingResult,
      this.arguments})
      : super._();

  @override
  final String name;
  @JsonKey(defaultValue: false)
  @override
  final bool isInitial;
  @override
  final PageBuilder builder;
  @override
  final Completer<dynamic>? pendingResult;
  @override
  final dynamic? arguments;

  @override
  String toString() {
    return 'PageData<$T>(name: $name, isInitial: $isInitial, builder: $builder, pendingResult: $pendingResult, arguments: $arguments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PageData<T> &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isInitial, isInitial) ||
                other.isInitial == isInitial) &&
            (identical(other.builder, builder) || other.builder == builder) &&
            (identical(other.pendingResult, pendingResult) ||
                other.pendingResult == pendingResult) &&
            const DeepCollectionEquality().equals(other.arguments, arguments));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, isInitial, builder,
      pendingResult, const DeepCollectionEquality().hash(arguments));

  @JsonKey(ignore: true)
  @override
  _$PageDataCopyWith<T, _PageData<T>> get copyWith =>
      __$PageDataCopyWithImpl<T, _PageData<T>>(this, _$identity);
}

abstract class _PageData<T extends Widget> extends PageData<T> {
  factory _PageData(
      {required String name,
      bool isInitial,
      required PageBuilder builder,
      Completer<dynamic>? pendingResult,
      dynamic? arguments}) = _$_PageData<T>;
  _PageData._() : super._();

  @override
  String get name;
  @override
  bool get isInitial;
  @override
  PageBuilder get builder;
  @override
  Completer<dynamic>? get pendingResult;
  @override
  dynamic? get arguments;
  @override
  @JsonKey(ignore: true)
  _$PageDataCopyWith<T, _PageData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
