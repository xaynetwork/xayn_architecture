import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:xayn_readability/xayn_readability.dart';

part 'result_card_state.freezed.dart';

@freezed
class ResultCardState with _$ResultCardState {
  const ResultCardState._();

  const factory ResultCardState({
    @Default(false) bool isComplete,
    ProcessHtmlResult? result,
    @Default([]) List<String> paragraphs,
    @Default([]) List<String> images,
    PaletteGenerator? paletteGenerator,
  }) = _ResultCardState;

  factory ResultCardState.initial() => const ResultCardState();

  factory ResultCardState.error() => const ResultCardState();
}
