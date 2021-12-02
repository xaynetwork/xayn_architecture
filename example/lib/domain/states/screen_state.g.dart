// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ScreenState _$$_ScreenStateFromJson(Map<String, dynamic> json) =>
    _$_ScreenState(
      results: json['results'] as List<dynamic>?,
      resultIndex: json['resultIndex'] as int,
      isComplete: json['isComplete'] as bool,
      isInErrorState: json['isInErrorState'] as bool,
    );

Map<String, dynamic> _$$_ScreenStateToJson(_$_ScreenState instance) =>
    <String, dynamic>{
      'results': instance.results,
      'resultIndex': instance.resultIndex,
      'isComplete': instance.isComplete,
      'isInErrorState': instance.isInErrorState,
    };
