import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/dicovery_results_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/result_combiner_use_case.dart';

@injectable
class NewsFeedManager extends HydratedCubit<ScreenState>
    with UseCaseBlocHelper<ScreenState> {
  NewsFeedManager(
    this._discoveryResultsUseCase,
  ) : super(ScreenState.empty());

  final DiscoveryResultsUseCase _discoveryResultsUseCase;

  @override
  void initHandlers() {
    consume(
      _discoveryResultsUseCase,
      initialData: 3,
    )
        .transform(
          (out) => out.asyncExpand((it) => it.isComplete
              ? Stream.value(it.results)
                  .followedBy(ResultCombinerUseCase(state.results))
              : Stream.value(state.results)),
        )
        .fold(
          onSuccess: (it) => state.copyWith(
            results: it,
            hasError: false,
          ), // todo: instead of null, a loading state
          onFailure: HandleFailure((e, s) {
            //print('$e $s');
            return ScreenState.error();
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
