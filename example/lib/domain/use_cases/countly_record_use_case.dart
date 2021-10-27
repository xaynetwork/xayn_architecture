import 'dart:developer';

import 'package:xayn_architecture/xayn_architecture.dart';

class CountlyRecordUseCase<T> extends UseCase<T, T> {
  final CountlyRecordMetadata metadata;

  CountlyRecordUseCase._(this.metadata);

  factory CountlyRecordUseCase(CountlyRecordMetadata metadata) =>
      CountlyRecordUseCase._(metadata);

  @override
  Stream<T> transaction(T param) async* {
    log('County recorded: $metadata, event: $param');
    yield param;
  }
}

class CountlyRecordMetadata {
  final String eventName;
  final DateTime timeStamp;

  const CountlyRecordMetadata({
    required this.eventName,
    required this.timeStamp,
  });

  @override
  String toString() => {
        'eventName': eventName,
        'timeStamp': timeStamp,
      }.toString();
}

extension CountlyRecordExtension<In> on Stream<In> {
  Stream<In> countlyRecord(CountlyRecordMetadata metadata) =>
      followedBy(CountlyRecordUseCase(metadata));
}
