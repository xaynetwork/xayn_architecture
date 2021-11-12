import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/concepts/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture_example/domain/states/result_card_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/cards/palette_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/readability/html_fetcher_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/readability/make_readable_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/readability/process_html_use_case.dart';

typedef UriHandler = void Function(Uri uri);

@injectable
class ResultCardManager extends Cubit<ResultCardState>
    with UseCaseBlocHelper<ResultCardState> {
  final HtmlFetcherUseCase _htmlFetcherUseCase;
  final MakeReadableUseCase _makeReadableUseCase;
  final ProcessHtmlUseCase _processHtmlUseCase;
  final PaletteUseCase _paletteUseCase;

  late final UriHandler _updateUri;
  late final UriHandler _updateImageUri;

  ResultCardManager(
    this._htmlFetcherUseCase,
    this._makeReadableUseCase,
    this._processHtmlUseCase,
    this._paletteUseCase,
  ) : super(ResultCardState.initial()) {
    init();
  }

  void updateUri(Uri uri) => _updateUri(uri);

  void updateImageUri(Uri uri) => _updateImageUri(uri);

  Future<void> init() async {
    _updateUri = pipe(_htmlFetcherUseCase)
        .transform(
          (out) => out
              .maybeResolveEarly(
                condition: (it) => !it.isCompleted,
                stateBuilder: (it) => state.copyWith(isComplete: false),
              )
              .map(_createReadabilityConfig)
              .followedBy(_makeReadableUseCase)
              .followedBy(_processHtmlUseCase),
        )
        .fold(
          onSuccess: (it) => state.copyWith(
            result: it.processHtmlResult,
            paragraphs: it.paragraphs,
            images: it.images,
          ),
          onFailure: HandleFailure((e, st) {
            log('e: $e, st: $st');
            return ResultCardState.error();
          }, matchers: {
            On<TimeoutException>((e, st) => ResultCardState.error()),
            On<FormatException>((e, st) => ResultCardState.error()),
          }),
        );

    _updateImageUri = pipe(_paletteUseCase).fold(
      onSuccess: (it) => state.copyWith(paletteGenerator: it),
      onFailure: HandleFailure(
        (e, st) {
          log('e: $e, st: $st');
          return ResultCardState.error();
        },
      ),
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
