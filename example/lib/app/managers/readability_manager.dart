import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/concepts/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/readability/html_fetcher_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/readability/make_readable_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/readability/process_html_use_case.dart';
import 'package:xayn_readability/xayn_readability.dart';

typedef UriHandler = void Function(Uri uri);

@injectable
class ReadabilityManager extends Cubit<ReadabilityState>
    with UseCaseBlocHelper<ReadabilityState> {
  final HtmlFetcherUseCase _htmlFetcherUseCase;
  final MakeReadableUseCase _makeReadableUseCase;
  final ProcessHtmlUseCase _processHtmlUseCase;

  late final UriHandler _updateUri;

  ReadabilityManager(
    this._htmlFetcherUseCase,
    this._makeReadableUseCase,
    this._processHtmlUseCase,
  ) : super(const ReadabilityState.initial());

  void updateUri(Uri uri) => _updateUri(uri);

  @override
  Future<void> initHandlers() async {
    _updateUri = pipe(_htmlFetcherUseCase)
        .transform(
          (out) => out
              .maybeResolveEarly(
                condition: (it) => !it.isCompleted,
                stateBuilder: (it) => const ReadabilityState.loading(),
              )
              .map(_createReadabilityConfig)
              .followedBy(_makeReadableUseCase)
              .followedBy(_processHtmlUseCase),
        )
        .fold(
          onSuccess: (it) => ReadabilityState.ready(
            result: it.processHtmlResult,
            paragraphs: it.paragraphs,
          ),
          onFailure: HandleFailure((e, st) {
            log('e: $e, st: $st');
            return const ReadabilityState.error();
          }, matchers: {
            On<TimeoutException>((e, st) => const ReadabilityState.error())
          }),
          guard: (next) {
            // filter out excessive loading or initial states
            if (!state.isComplete && !next.isComplete) return false;

            return true;
          },
        );
  }

  MakeReadableConfig _createReadabilityConfig(HtmlFetcherProgress progress) =>
      MakeReadableConfig(
        uri: progress.uri,
        html: progress.html,
        disableJsonLd: true,
        classesToPreserve: const [],
      );
}

class ReadabilityState {
  final bool isComplete;
  final ProcessHtmlResult? result;
  final List<String> paragraphs;

  const ReadabilityState.initial()
      : isComplete = false,
        paragraphs = const [],
        result = null;

  const ReadabilityState.loading()
      : isComplete = false,
        paragraphs = const [],
        result = null;

  const ReadabilityState.error()
      : isComplete = true,
        paragraphs = const [],
        result = null;

  const ReadabilityState.ready({
    required this.result,
    required this.paragraphs,
  }) : isComplete = true;
}
