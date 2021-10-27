import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';
import 'package:xayn_architecture_example/domain/use_cases/news_feed/news_feed.dart';
import 'package:xayn_architecture_example/domain/use_cases/logger_use_case.dart';

const List<String> randomKeywords = [
  'german',
  'french',
  'english',
  'american',
  'hollywood',
  'music',
  'broadway',
  'football',
  'tennis',
  'covid',
  'trump',
  'merkel',
  'cars',
  'sports',
  'market',
  'economy',
  'financial',
];

@singleton
class DiscoveryApi extends Cubit<DiscoveryApiState>
    with UseCaseBlocHelper<DiscoveryApiState> {
  final RequestBuilderUseCase _requestBuilderUseCase;
  final CallEndpointUseCase _callEndpointUseCase;
  final DeserializeResultUseCase _deserializeResultUseCase;
  final Random rnd = Random();

  late final Handler<String> _handleQuery;

  late String nextFakeKeyword;

  DiscoveryApi(
    this._requestBuilderUseCase,
    this._callEndpointUseCase,
    this._deserializeResultUseCase,
  ) : super(const DiscoveryApiState.initial()) {
    nextFakeKeyword = randomKeywords[rnd.nextInt(randomKeywords.length)];

    _handleQuery = pipe(_requestBuilderUseCase)
        .transform(
          (out) => out
              .followedBy(LoggerUseCase((it) => 'will fetch $it'))
              .followedBy(_callEndpointUseCase)
              .followedBy(_deserializeResultUseCase)
              .followedBy(LoggerUseCase(
                (it) => 'did fetch ${it.results.length} results',
                when: (it) => it.isComplete,
              )),
        )
        .fold(
          onSuccess: (it, state) => it.isComplete
              ? _extractFakeKeywordAndEmit(it.results)
              : const DiscoveryApiState(results: [], isComplete: false),
          onFailure: (e, s, state) {
            //print('$e $s');
            return DiscoveryApiState.error(error: e, stackTrace: s);
          },
        );
  }

  void handleQuery(String value) {
    _handleQuery(nextFakeKeyword);
  }

  DiscoveryApiState _extractFakeKeywordAndEmit(List<Result> nextResults) {
    nextFakeKeyword = _fakeNextKeywork(nextResults);

    if (nextResults.isEmpty) {
      _handleQuery(nextFakeKeyword);
    }

    return DiscoveryApiState(results: nextResults, isComplete: true);
  }

  /// selects a random word from the combined set of [Result.description]s.
  String _fakeNextKeywork(List<Result> nextResults) {
    if (nextResults.isEmpty) {
      return randomKeywords[rnd.nextInt(randomKeywords.length)];
    }

    final words = nextResults
        .map((it) => it.description)
        .join(' ')
        .split(RegExp(r'[\s]+'))
        .where((it) => it.length >= 5)
        .toList(growable: false);

    if (words.isEmpty) {
      return randomKeywords[rnd.nextInt(randomKeywords.length)];
    }

    return words[rnd.nextInt(words.length)];
  }
}

class DiscoveryApiEvent {
  final String query;

  const DiscoveryApiEvent({required this.query});
}

class DiscoveryApiState {
  final List<Result> results;
  final bool isComplete;
  final Object? error;
  final StackTrace? stackTrace;

  const DiscoveryApiState({
    required this.results,
    required this.isComplete,
  })  : error = null,
        stackTrace = null;

  const DiscoveryApiState.initial()
      : results = const [],
        isComplete = false,
        error = null,
        stackTrace = null;

  const DiscoveryApiState.error({
    required this.error,
    required this.stackTrace,
  })  : results = const [],
        isComplete = false;
}
