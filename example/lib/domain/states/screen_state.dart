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
    required bool isInErrorState,
  }) = _ScreenState;

  factory ScreenState.empty() => const ScreenState(
        resultIndex: 0,
        isComplete: false,
        isInErrorState: false,
      );

  factory ScreenState.fromJson(Map<String, dynamic> json) =>
      _$ScreenStateFromJson(json);
}
