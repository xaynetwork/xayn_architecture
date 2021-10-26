library use_case_bloc_helper;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/transformers.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture/concepts/use_case/use_case_base.dart';

part 'use_case_resolver.dart';
part 'use_case_subject.dart';

/// A method signature, defines a Function with exactly one parameter.
/// Used in or `cubit`s to define handlers that are exposed to widgets.
typedef OnHandler<Next> = void Function(Next data);

/// A mixin which exposes [UseCase] helper methods for binding changes to the [BlocBase.state]
mixin UseCaseBlocHelper<State> on BlocBase<State> {
  final List<StreamController> _subjects = <StreamController>[];
  final List<StreamSubscription<State?>> _subscriptions =
      <StreamSubscription<State?>>[];
  var _didInitHandlers = false;

  @override
  Stream<State> get stream {
    if (!_didInitHandlers) {
      _didInitHandlers = true;

      initHandlers();
    }

    return super.stream;
  }

  /// [initHandlers] is called right after `BlocBase` is created,
  /// override this handler to setup any [OnHandler] methods.
  ///
  /// ```dart
  /// late final OnHandler<User> _onUserUpdate;
  ///
  /// void onUserUpdate(User user) => _onUserUpdate(user);
  ///
  /// @override
  /// void initHandlers() {
  ///   _onUserUpdate = pipe(_userUpdateUseCase).fold(
  ///     onSuccess: (it, state) => state.copyWith(
  ///       user: it,
  ///       hasError: false,
  ///     ),
  ///     onFailure: (e, s, state) => ScreenState.error(),
  ///   );
  /// }
  /// ```
  void initHandlers() {}

  bool willEmit(
    State currentState,
    State nextState,
    dynamic identity,
  ) {
    return true;
  }

  @override
  Future<void> close() {
    for (var it in _subscriptions) {
      it.cancel();
    }
    for (var subject in _subjects) {
      subject.close();
    }

    _subscriptions.clear();
    _subjects.clear();

    return super.close();
  }

  /// Consumes the [useCase] as a `Stream` and wraps the `Sink.add` handler,
  /// which can then be resolved to a `Cubit`'s state.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel],
  /// or use [UseCaseSinkResolver.close] to terminate the `sink`.
  ///
  /// When using [UseCaseSinkResolver.close], then be aware that any future
  /// incoming events will throw a [StateError] on that same `sink`.
  _SinkResolver<In, Out, State> pipe<Identity, In, Out>(
      UseCase<In, Out> useCase,
      {Identity? identity}) {
    final controller = StreamController<In>.broadcast();
    final stream = controller.stream.followedBy(useCase);

    _subjects.add(controller);

    return _SinkResolver(
      stream,
      () => state,
      (State? nextState) {
        if (nextState != null && willEmit(state, nextState, identity)) {
          emit(state);
        }
      },
      _subscriptions,
      controller.sink,
    );
  }

  /// Consumes the [useCase] as an open `Stream`.
  /// The connection stays open, until `close` is called on the `Cubit`.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel].
  UseCaseResolver<In, Out, State> consume<Identity, In, Out>(
    UseCase<In, Out> useCase, {
    required In initialData,
    Identity? identity,
  }) =>
      _Resolver(
        Stream.value(initialData).followedBy(useCase),
        () => state,
        (State? nextState) {
          if (nextState != null && willEmit(state, nextState, identity)) {
            emit(state);
          }
        },
        _subscriptions,
      );
}
