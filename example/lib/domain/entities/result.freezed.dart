// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Result _$ResultFromJson(Map<String, dynamic> json) {
  return _Result.fromJson(json);
}

/// @nodoc
class _$ResultTearOff {
  const _$ResultTearOff();

  _Result call(Uri uri, Uri? imageUri, String description) {
    return _Result(
      uri,
      imageUri,
      description,
    );
  }

  Result fromJson(Map<String, Object?> json) {
    return Result.fromJson(json);
  }
}

/// @nodoc
const $Result = _$ResultTearOff();

/// @nodoc
mixin _$Result {
  Uri get uri => throw _privateConstructorUsedError;
  Uri? get imageUri => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResultCopyWith<Result> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<$Res> {
  factory $ResultCopyWith(Result value, $Res Function(Result) then) =
      _$ResultCopyWithImpl<$Res>;
  $Res call({Uri uri, Uri? imageUri, String description});
}

/// @nodoc
class _$ResultCopyWithImpl<$Res> implements $ResultCopyWith<$Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  final Result _value;
  // ignore: unused_field
  final $Res Function(Result) _then;

  @override
  $Res call({
    Object? uri = freezed,
    Object? imageUri = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      uri: uri == freezed
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      imageUri: imageUri == freezed
          ? _value.imageUri
          : imageUri // ignore: cast_nullable_to_non_nullable
              as Uri?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ResultCopyWith<$Res> implements $ResultCopyWith<$Res> {
  factory _$ResultCopyWith(_Result value, $Res Function(_Result) then) =
      __$ResultCopyWithImpl<$Res>;
  @override
  $Res call({Uri uri, Uri? imageUri, String description});
}

/// @nodoc
class __$ResultCopyWithImpl<$Res> extends _$ResultCopyWithImpl<$Res>
    implements _$ResultCopyWith<$Res> {
  __$ResultCopyWithImpl(_Result _value, $Res Function(_Result) _then)
      : super(_value, (v) => _then(v as _Result));

  @override
  _Result get _value => super._value as _Result;

  @override
  $Res call({
    Object? uri = freezed,
    Object? imageUri = freezed,
    Object? description = freezed,
  }) {
    return _then(_Result(
      uri == freezed
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      imageUri == freezed
          ? _value.imageUri
          : imageUri // ignore: cast_nullable_to_non_nullable
              as Uri?,
      description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Result extends _Result {
  const _$_Result(this.uri, this.imageUri, this.description) : super._();

  factory _$_Result.fromJson(Map<String, dynamic> json) =>
      _$$_ResultFromJson(json);

  @override
  final Uri uri;
  @override
  final Uri? imageUri;
  @override
  final String description;

  @override
  String toString() {
    return 'Result(uri: $uri, imageUri: $imageUri, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Result &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.imageUri, imageUri) ||
                other.imageUri == imageUri) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uri, imageUri, description);

  @JsonKey(ignore: true)
  @override
  _$ResultCopyWith<_Result> get copyWith =>
      __$ResultCopyWithImpl<_Result>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ResultToJson(this);
  }
}

abstract class _Result extends Result {
  const factory _Result(Uri uri, Uri? imageUri, String description) = _$_Result;
  const _Result._() : super._();

  factory _Result.fromJson(Map<String, dynamic> json) = _$_Result.fromJson;

  @override
  Uri get uri;
  @override
  Uri? get imageUri;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$ResultCopyWith<_Result> get copyWith => throw _privateConstructorUsedError;
}
