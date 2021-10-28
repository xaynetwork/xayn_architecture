// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ScreenState _$$_ScreenStateFromJson(Map<String, dynamic> json) =>
    _$_ScreenState(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasError: json['hasError'] as bool?,
    );

Map<String, dynamic> _$$_ScreenStateToJson(_$_ScreenState instance) =>
    <String, dynamic>{
      'results': instance.results,
      'hasError': instance.hasError,
    };
