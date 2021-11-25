import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

part 'navigator_state.freezed.dart';

@freezed
class NavigatorState with _$NavigatorState {
  const NavigatorState._();

  factory NavigatorState({required List<PageData<dynamic>> pages}) =
      _NavigatorState;
}
