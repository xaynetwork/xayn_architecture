import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/discovery_engine/dicovery_results_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/discovery_engine/result_combiner_use_case.dart';

@injectable
class NewsFeedManager extends Cubit<ScreenState>
    with UseCaseBlocHelper<ScreenState> {
  NewsFeedManager(
    this._discoveryResultsUseCase,
  ) : super(ScreenState.empty()) {
    _initHandlers();
  }

  final DiscoveryResultsUseCase _discoveryResultsUseCase;
  late final UseCaseValueStream<ResultCombinerJob> _discoveryResults;

  void handleResultIndex(int index) => emit(state.copyWith(
        resultIndex: index,
      ));

  @override
  Future<ScreenState> computeState() async {
    var nextState = state;

    _discoveryResults.fold(
      defaultOnError: (e, s) {
        nextState = nextState.copyWith(
          isInErrorState: true,
        );
      },
      onValue: (it) {
        nextState = nextState.copyWith(
          results: it.documents,
          resultIndex: (nextState.resultIndex - it.removed)
              .clamp(0, it.documents.length),
          isComplete: it.apiState.isComplete,
          isInErrorState: false,
        );
      },
      matchOnError: {
        On<TimeoutException>((e, s) => nextState = nextState.copyWith(
              isInErrorState: true,
            ))
      },
    );

    return nextState;
  }

  void _initHandlers() {
    _discoveryResults = consume(_discoveryResultsUseCase, initialData: 3)
        .transform((out) =>
            out.followedBy(ResultCombinerUseCase(() => state.results)));
  }
}
