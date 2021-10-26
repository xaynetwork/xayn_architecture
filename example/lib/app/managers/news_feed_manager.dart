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
class NewsFeedManager extends HydratedCubit<ScreenState>
    with UseCaseBlocHelper<ScreenState> {
  NewsFeedManager(
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
    //
    // discoveryResultsUseCase will simply emit a new List<Result> every time,
    // we need to add the incoming ones, but also keep a total of 5 Results always,
    // so if we receive too few Results, then we keep old ones.
    //
    // in this example, the use case always emits a List of 3,
    // we then use pairwise to compare the old list vs the new one,
    // and finally pass them both to resultCombinerUseCase which will then
    // guarantee a final List of 5 Results for the state update.
    consume(_discoveryResultsUseCase, initialData: 3)
        .transform(
          (out) => out
              // notify Countly that a new request was made
              .countlyRecord(CountlyRecordMetadata(
                eventName: 'requested more results',
                timeStamp: DateTime.now(),
              ))
              // in the beginning, there was nothing...
              // we actually need to add this, because pairwise waits until it sees 2 events
              .startWith(const [])
              // buffer previous and new results, see [Rx.pairwise](https://rxmarbles.com/#pairwise)
              .pairwise()
              // combine previous and new results into a new List
              .followedBy(_resultCombinerUseCase),
        )
        .fold(
          identity: 'discoveryApi',
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
