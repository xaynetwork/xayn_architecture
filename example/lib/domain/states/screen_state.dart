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
    required int resultIndex,
    required bool isComplete,
  }) = _ScreenState;

  factory ScreenState.empty() => const _ScreenState(
        resultIndex: 0,
        isComplete: false,
      );

  factory ScreenState.fromJson(Map<String, dynamic> json) =>
      _$ScreenStateFromJson(json);
}

@freezed
class ScreenErrorState extends ScreenState with _$ScreenErrorState {
  const ScreenErrorState._() : super._();

  const factory ScreenErrorState() = _ScreenErrorState;

  factory ScreenErrorState.fromJson(Map<String, dynamic> json) =>
      _$ScreenErrorStateFromJson(json);
}
