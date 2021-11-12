library use_case_bloc_helper;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/transformers.dart';
import 'package:xayn_architecture/concepts/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture/concepts/use_case/emit_on_transformer.dart';
import 'package:xayn_architecture/concepts/use_case/use_case_base.dart';

part 'use_case_resolver.dart';
part 'use_case_subject.dart';

/// A method signature, defines a Function with exactly one parameter.
/// Used in or `cubit`s to define handlers that are exposed to widgets.
typedef Handler<Next> = void Function(Next data);

/// A mixin which exposes [UseCase] helper methods for binding changes to the [BlocBase.state]
mixin UseCaseBlocHelper<State> on BlocBase<State> {
  final List<StreamController> _subjects = <StreamController>[];
  final List<StreamSubscription<State?>> _subscriptions =
      <StreamSubscription<State?>>[];

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

  State? computeState(
    State currentState,
    State? nextState,
    UseCase useCase,
  ) =>
      nextState;

  /// Consumes the [useCase] as a `Stream` and wraps the `Sink.add` handler,
  /// which can then be resolved to a `Cubit`'s state.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel],
  /// or use [UseCaseSinkResolver.close] to terminate the `sink`.
  ///
  /// When using [UseCaseSinkResolver.close], then be aware that any future
  /// incoming events will throw a [StateError] on that same `sink`.
  _SinkResolver<In, Out, State> pipe<In, Out>(
    UseCase<In, Out> useCase,
  ) {
    final controller = StreamController<In>.broadcast();
    final stream = controller.stream.followedBy(useCase);

    _subjects.add(controller);

    return _SinkResolver(
      stream,
      (State? nextState) {
        final computedState = computeState(state, nextState, useCase);

        if (computedState != null) {
          emit(computedState);
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
  UseCaseResolver<In, Out, State> consume<In, Out>(
    UseCase<In, Out> useCase, {
    required In initialData,
  }) =>
      _Resolver(
        Stream.value(initialData).followedBy(useCase),
        (State? nextState) {
          final computedState = computeState(state, nextState, useCase);

          if (computedState != null) {
            emit(computedState);
          }
        },
        _subscriptions,
      );
}
