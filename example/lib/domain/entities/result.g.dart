// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Result _$$_ResultFromJson(Map<String, dynamic> json) => _$_Result(
      Uri.parse(json['uri'] as String),
      json['imageUri'] == null ? null : Uri.parse(json['imageUri'] as String),
      json['description'] as String,
    );

Map<String, dynamic> _$$_ResultToJson(_$_Result instance) => <String, dynamic>{
      'uri': instance.uri.toString(),
      'imageUri': instance.imageUri?.toString(),
      'description': instance.description,
    };
