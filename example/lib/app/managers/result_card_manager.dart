import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:palette_generator/palette_generator.dart';
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

  late final UseCaseSink<Uri, WebsiteParagraphs> _updateUri;
  late final UseCaseSink<Uri, PaletteGenerator> _updateImageUri;

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

  @override
  Future<ResultCardState?> computeState() async =>
      fold2(_updateUri, _updateImageUri).foldAll((a, b, errorReport) {
        if (errorReport.isNotEmpty) {
          return ResultCardState.error();
        }

        var nextState = state.copyWith(paletteGenerator: b);

        if (a != null) {
          nextState.copyWith(
            result: a.processHtmlResult,
            paragraphs: a.paragraphs,
            images: a.images,
          );
        }

        return nextState;
      });

  Future<void> init() async {
    _updateUri = pipe(_htmlFetcherUseCase).transform(
      (out) => out
          .scheduleComputeState(
            condition: (it) => !it.isCompleted,
            whenTrue: (it) => state.copyWith(isComplete: false),
          )
          .map(_createReadabilityConfig)
          .followedBy(_makeReadableUseCase)
          .followedBy(_processHtmlUseCase),
    );

    _updateImageUri = pipe(_paletteUseCase);
  }

  MakeReadableConfig _createReadabilityConfig(HtmlFetcherProgress progress) =>
      MakeReadableConfig(
        uri: progress.uri,
        html: progress.html,
        disableJsonLd: true,
        classesToPreserve: const [],
      );
}
