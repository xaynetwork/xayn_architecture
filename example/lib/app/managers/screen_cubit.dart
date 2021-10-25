import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/countly_record_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/print_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/scroll_update_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/user_update_use_case.dart';

@injectable
class ScreenCubit extends HydratedCubit<ScreenState> with UseCaseBlocHelper {
  /// The [ScreenCubit] is responsible for managing the [state] of a single screen.
  ///
  /// Since it is also a [HydratedCubit], we can leverage functionality to persist the [state] via Hive automatically,
  /// see [fromJson] and [toJson].
  ///
  /// As a rule, the [state] can only be created as the outcome of one or more [UseCase]s.
  /// Here, we want to update the [state] using a [User] and a scroll position.
  /// - the [User] is handled via a [UserUpdateUseCase]
  /// - the scroll position via a [ScrollUpdateUseCase]
  ///
  /// To update state, we declare onX handlers:
  /// - [onUserUpdate]
  /// - [onScrollUpdate]
  ///
  /// [onUserUpdate] is treated in a standard way, i.e. in that every call here, will update [state].
  /// [onScrollUpdate] could be triggered in a rapid sequence of position updates,
  /// yet we don't want to trigger [state] emission every time, but just for the latest value instead.
  ///
  /// To treat the above [UseCase]s differently, a mixin called [UseCaseBlocHelper] is used.
  ///
  /// This mixin exposes [emitAll] and [emitLatestOnly], and we override [initEmitters] to
  /// bind our [UseCase]s to the [state] with different behavior.
  ///
  /// However, due to the dynamic nature of [UseCase], it's perfectly fine to also just call
  /// it in a classic way, e.g.:
  ///
  /// ```dart
  /// Future<void> onUserUpdateClassic(User user) async {
  ///   final result = await _userUpdateUseCase(user);
  ///   final updatedUser = result.data!;
  ///
  ///   emit(state.copyWith(user: updatedUser));
  /// }
  /// ```
  ScreenCubit(
    this._userUpdateUseCase,
    this._scrollUpdateUseCase,
  ) : super(ScreenState.empty());

  late final OnHandler<User> _onUserUpdate;
  late final OnHandler<int> _onScrollUpdate;

  final UserUpdateUseCase _userUpdateUseCase;
  final ScrollUpdateUseCase _scrollUpdateUseCase;

  @override
  void initHandlers() {
    consume(_scrollUpdateUseCase, initialData: 1)
        .transform(
          (out) => out.followedBy(PrintUseCase<int>()),
        )
        .fold(
          onSuccess: (it, state) => state.copyWith(
            position: it,
            hasError: false,
          ),
          onFailure: (e, s, state) => ScreenState.error(),
        );

    _onUserUpdate = pipe(_userUpdateUseCase).fold(
      onSuccess: (it, state) => state.copyWith(
        user: it,
        hasError: false,
      ),
      onFailure: (e, s, state) => ScreenState.error(),
    );

    _onScrollUpdate = pipe(_scrollUpdateUseCase)
        .transform((out) => out
            .countlyRecord(CountlyRecordMetadata(
              eventName: 'scroll update',
              timeStamp: DateTime.now(),
            ))
            .followedBy(PrintUseCase<int>()))
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
