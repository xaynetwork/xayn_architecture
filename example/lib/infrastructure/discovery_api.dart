import 'dart:async';
import 'dart:math';

import 'package:xayn_discovery_engine/discovery_engine.dart' as xayn;
// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/events/base_events.dart';
// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/events/search_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';
import 'package:xayn_architecture_example/domain/use_cases/news_feed/bing_call_endpoint_use_case.dart';
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
    with UseCaseBlocHelper<DiscoveryApiState>
    implements xayn.DiscoveryEngine {
  final RequestBuilderUseCase _requestBuilderUseCase;
  final CallEndpointUseCase _callEndpointUseCase;
  final StreamController<ClientEvent> _onClientEvent =
      StreamController<ClientEvent>();
  late final StreamSubscription<ClientEvent> _clientEventSubscription;
  final Random rnd = Random();

  late final UseCaseSink<String, ResultsContainer> _handleQuery;

  late String nextFakeKeyword;

  bool _isLoading = false;

  Sink<ClientEvent> get onClientEvent => _onClientEvent.sink;

  DiscoveryApi(
    this._requestBuilderUseCase,
    this._callEndpointUseCase,
  ) : super(const DiscoveryApiState.initial()) {
    _initGeneral();
    _initHandlers();
  }

  @override
  Future<void> close() {
    _onClientEvent.close();
    _clientEventSubscription.cancel();

    return super.close();
  }

  @override
  Future<DiscoveryApiState> computeState() async {
    if (_isLoading) return const DiscoveryApiState.loading();

    var nextState = state;

    _handleQuery.fold(
      defaultOnError: (e, s) {
        nextState = DiscoveryApiState.error(
          error: e,
          stackTrace: s,
        );
      },
      onValue: (it) {
        nextState = _extractFakeKeywordAndEmit(it.results);
      },
    );

    return nextState;
  }

  void _initGeneral() {
    nextFakeKeyword = randomKeywords[rnd.nextInt(randomKeywords.length)];

    _clientEventSubscription = _onClientEvent.stream.listen(_handleClientEvent);
  }

  void _initHandlers() {
    _handleQuery = pipe(_requestBuilderUseCase).transform(
      (out) => out
          .followedBy(LoggerUseCase((it) => 'will fetch $it'))
          .followedBy(_callEndpointUseCase)
          .scheduleComputeState(
              consumeEvent: (data) => !data.isComplete,
              run: (data) => _isLoading = !data.isComplete)
          .followedBy(
            LoggerUseCase(
              (it) => 'did fetch ${it.results.length} results',
              when: (it) => it.isComplete,
            ),
          ),
    );
  }

  void _handleClientEvent(ClientEvent event) {
    if (event is SearchRequested) _handleSearchEvent(event);
  }

  void _handleSearchEvent(SearchRequested event) {
    // ignore event query for now
    _handleQuery(nextFakeKeyword);
  }

  DiscoveryApiState _extractFakeKeywordAndEmit(List<Document> nextResults) {
    nextFakeKeyword = _fakeNextKeywork(nextResults);

    if (nextResults.isEmpty) {
      _handleQuery(nextFakeKeyword);
    }

    return DiscoveryApiState(results: nextResults, isComplete: true);
  }

  /// selects a random word from the combined set of [Result.description]s.
  String _fakeNextKeywork(List<Document> nextResults) {
    if (nextResults.isEmpty) {
      return randomKeywords[rnd.nextInt(randomKeywords.length)];
    }

    final words = nextResults
        .map((it) => it.webResource.snippet)
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

class DiscoveryApiState {
  final List<Document> results;
  final bool isComplete;
  final Object? error;
  final StackTrace? stackTrace;

  bool get isLoading => !isComplete && results.isEmpty && !hasError;

  bool get hasError => error != null;

  DiscoveryApiState({
    required this.results,
    required this.isComplete,
  })  : error = null,
        stackTrace = null;

  const DiscoveryApiState.initial()
      : results = const [],
        isComplete = false,
        error = null,
        stackTrace = null;

  const DiscoveryApiState.loading()
      : results = const [],
        isComplete = false,
        error = null,
        stackTrace = null;

  DiscoveryApiState.error({
    required this.error,
    required this.stackTrace,
  })  : results = const [],
        isComplete = false {
    // ignore: avoid_print
    print('e: $error, st: $stackTrace');
  }
}
