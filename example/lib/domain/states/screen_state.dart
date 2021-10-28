import 'package:xayn_architecture_example/domain/entities/document.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'screen_state.freezed.dart';
part 'screen_state.g.dart';

@freezed
class ScreenState with _$ScreenState {
  const ScreenState._();

  const factory ScreenState({
    List<Document>? results,
    bool? hasError,
  }) = _ScreenState;

  factory ScreenState.empty() => const _ScreenState(hasError: false);

  factory ScreenState.loading() => const _ScreenState(hasError: false);

  factory ScreenState.error() => const _ScreenState(hasError: true);

  factory ScreenState.fromJson(Map<String, dynamic> json) =>
      _$ScreenStateFromJson(json);
}
