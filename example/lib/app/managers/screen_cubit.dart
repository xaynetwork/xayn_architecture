import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/countly_record_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/dicovery_results_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/result_combiner_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/scroll_update_use_case.dart';

@injectable
class ScreenCubit extends HydratedCubit<ScreenState> with UseCaseBlocHelper {
  ScreenCubit(
    this._discoveryResultsUseCase,
    this._resultCombinerUseCase,
    this._scrollUpdateUseCase,
  ) : super(ScreenState.empty());

  late final OnHandler<User> _onUserUpdate;
  late final OnHandler<int> _onScrollUpdate;

  final DiscoveryResultsUseCase _discoveryResultsUseCase;
  final ResultCombinerUseCase _resultCombinerUseCase;
  final ScrollUpdateUseCase _scrollUpdateUseCase;

  @override
  void initHandlers() {
    // open a socket connection to the discovery api.
    // request 3 Results on init, then keep the connection open to
    // receive updates.
    consume(_discoveryResultsUseCase, initialData: 3)
        .transform(
          (out) => out
              // notify Countly that a new request was made
              .countlyRecord(CountlyRecordMetadata(
                eventName: 'requested more results',
                timeStamp: DateTime.now(),
              ))
              // buffer previous and new results, see [Rx.pairwise](https://rxmarbles.com/#pairwise)
              .pairwise()
              // combine previous and new results into a new List
              .followedBy(_resultCombinerUseCase),
        )
        .fold(
          onSuccess: (it, state) => state.copyWith(
            results: it,
            hasError: false,
          ),
          onFailure: (e, s, state) => ScreenState.error(),
        );

    // trigger each time the use scrolls.
    // scroll events are debounced on the input side, see [ScrollUpdateUseCase.transform]
    _onScrollUpdate = pipe(_scrollUpdateUseCase)
        .transform(
          (out) => out
              // notify Countly that the user scrolled
              .countlyRecord(CountlyRecordMetadata(
            eventName: 'scroll update',
            timeStamp: DateTime.now(),
          )),
        )
        .fold(
          onSuccess: (it, state) => state.copyWith(
            position: it,
            hasError: false,
          ),
          onFailure: (e, s, state) => ScreenState.error(),
        );
  }

  /// Updates the [state] by passing a [User].
  void onUserUpdate(User user) => _onUserUpdate(user);

  /// Updates the [state] by passing a scroll position.
  void onScrollUpdate(int position) => _onScrollUpdate(position);

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
