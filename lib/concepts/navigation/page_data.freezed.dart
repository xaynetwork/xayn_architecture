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

  _PageData<T, A> call<T extends Widget, A>(
      {required String name,
      bool isInitial = false,
      required PageBuilder builder,
      Completer<dynamic>? pendingResult,
      A? arguments}) {
    return _PageData<T, A>(
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
mixin _$PageData<T extends Widget, A> {
  String get name => throw _privateConstructorUsedError;
  bool get isInitial => throw _privateConstructorUsedError;
  PageBuilder get builder => throw _privateConstructorUsedError;
  Completer<dynamic>? get pendingResult => throw _privateConstructorUsedError;
  A? get arguments => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PageDataCopyWith<T, A, PageData<T, A>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageDataCopyWith<T extends Widget, A, $Res> {
  factory $PageDataCopyWith(
          PageData<T, A> value, $Res Function(PageData<T, A>) then) =
      _$PageDataCopyWithImpl<T, A, $Res>;
  $Res call(
      {String name,
      bool isInitial,
      PageBuilder builder,
      Completer<dynamic>? pendingResult,
      A? arguments});
}

/// @nodoc
class _$PageDataCopyWithImpl<T extends Widget, A, $Res>
    implements $PageDataCopyWith<T, A, $Res> {
  _$PageDataCopyWithImpl(this._value, this._then);

  final PageData<T, A> _value;
  // ignore: unused_field
  final $Res Function(PageData<T, A>) _then;

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
              as A?,
    ));
  }
}

/// @nodoc
abstract class _$PageDataCopyWith<T extends Widget, A, $Res>
    implements $PageDataCopyWith<T, A, $Res> {
  factory _$PageDataCopyWith(
          _PageData<T, A> value, $Res Function(_PageData<T, A>) then) =
      __$PageDataCopyWithImpl<T, A, $Res>;
  @override
  $Res call(
      {String name,
      bool isInitial,
      PageBuilder builder,
      Completer<dynamic>? pendingResult,
      A? arguments});
}

/// @nodoc
class __$PageDataCopyWithImpl<T extends Widget, A, $Res>
    extends _$PageDataCopyWithImpl<T, A, $Res>
    implements _$PageDataCopyWith<T, A, $Res> {
  __$PageDataCopyWithImpl(
      _PageData<T, A> _value, $Res Function(_PageData<T, A>) _then)
      : super(_value, (v) => _then(v as _PageData<T, A>));

  @override
  _PageData<T, A> get _value => super._value as _PageData<T, A>;

  @override
  $Res call({
    Object? name = freezed,
    Object? isInitial = freezed,
    Object? builder = freezed,
    Object? pendingResult = freezed,
    Object? arguments = freezed,
  }) {
    return _then(_PageData<T, A>(
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
              as A?,
    ));
  }
}

/// @nodoc

class _$_PageData<T extends Widget, A> extends _PageData<T, A> {
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
  final A? arguments;

  @override
  String toString() {
    return 'PageData<$T, $A>(name: $name, isInitial: $isInitial, builder: $builder, pendingResult: $pendingResult, arguments: $arguments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PageData<T, A> &&
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
  _$PageDataCopyWith<T, A, _PageData<T, A>> get copyWith =>
      __$PageDataCopyWithImpl<T, A, _PageData<T, A>>(this, _$identity);
}

abstract class _PageData<T extends Widget, A> extends PageData<T, A> {
  factory _PageData(
      {required String name,
      bool isInitial,
      required PageBuilder builder,
      Completer<dynamic>? pendingResult,
      A? arguments}) = _$_PageData<T, A>;
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
  A? get arguments;
  @override
  @JsonKey(ignore: true)
  _$PageDataCopyWith<T, A, _PageData<T, A>> get copyWith =>
      throw _privateConstructorUsedError;
}
