// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Document _$$_DocumentFromJson(Map<String, dynamic> json) => _$_Document(
      documentId: json['documentId'],
      webResource: json['webResource'],
      nonPersonalizedRank: json['nonPersonalizedRank'] as int,
      personalizedRank: json['personalizedRank'] as int,
    );

Map<String, dynamic> _$$_DocumentToJson(_$_Document instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'webResource': instance.webResource,
      'nonPersonalizedRank': instance.nonPersonalizedRank,
      'personalizedRank': instance.personalizedRank,
    };
