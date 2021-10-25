// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ScreenState _$$_ScreenStateFromJson(Map<String, dynamic> json) =>
    _$_ScreenState(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      position: json['position'] as int?,
      hasError: json['hasError'] as bool?,
    );

Map<String, dynamic> _$$_ScreenStateToJson(_$_ScreenState instance) =>
    <String, dynamic>{
      'user': instance.user,
      'position': instance.position,
      'hasError': instance.hasError,
    };
