import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/discovery_engine/dicovery_results_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/discovery_engine/result_combiner_use_case.dart';

@injectable
class NewsFeedManager extends HydratedCubit<ScreenState>
    with UseCaseBlocHelper<ScreenState> {
  NewsFeedManager(
    this._discoveryResultsUseCase,
  ) : super(ScreenState.empty());

  final DiscoveryResultsUseCase _discoveryResultsUseCase;

  void handleResultIndex(int index) => emit(state.copyWith(
        resultIndex: index,
      ));

  @override
  void initHandlers() {
    consume(_discoveryResultsUseCase, initialData: 3)
        .transform(
            (out) => out.followedBy(ResultCombinerUseCase(() => state.results)))
        .fold(
          onSuccess: (it) => state.copyWith(
            results: it.documents,
            resultIndex:
                (state.resultIndex - it.removed).clamp(0, it.documents.length),
            isComplete: it.apiState.isComplete,
            isInErrorState: false,
          ), // todo: instead of null, a loading state
          onFailure: HandleFailure((e, s) {
            //print('$e $s');
            return state.copyWith(
              isInErrorState: true,
            );
          }),
        );
  }

  /// we get this for free, thanks to
  /// - freezed
  /// - json_serializable
  @override
  ScreenState? fromJson(Map<String, dynamic> json) =>
      ScreenState.fromJson(json);

  /// we get this for free, thanks to
  /// - freezed
  /// - json_serializable
  @override
  Map<String, dynamic>? toJson(ScreenState state) => state.toJson();
}
