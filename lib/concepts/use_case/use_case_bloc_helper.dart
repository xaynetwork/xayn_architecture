library use_case_bloc_helper;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/xayn_architecture.dart';

/// A method signature, defines a Function with exactly one parameter.
/// Used in or `cubit`s to define handlers that are exposed to widgets.
typedef Handler<Next> = void Function(Next data);

/// A mixin which exposes [UseCase] helper methods for binding changes to the [BlocBase.state]
mixin UseCaseBlocHelper<State> on BlocBase<State> {
  final List<StreamController> _subjects = <StreamController>[];
  final CompositeSubscription _subscriptions = CompositeSubscription();
  var _didInitHandlers = false;

  @override
  Stream<State> get stream {
    if (!_didInitHandlers) {
      _didInitHandlers = true;

      _computeStateNow();
    }

    return super.stream;
  }

  /// Called whenever [pipe] or [consume] emits an event.
  ///
  /// Use this handler to combine all active [Either] constructs at once,
  /// in a synchronous way.
  ///
  /// See [fold] to combine multiple instances, or simply process each `Either`
  /// individually.
  ///
  /// @override
  ///   Future<ResultCardState?> computeState() async =>
  ///     fold2(_a, _b).foldAll((a, b, errorReport) {
  ///       if (errorReport.isNotEmpty) {
  ///         if (errorReport.exists(_a) {
  ///           return State.error(errorReport.of(_a));
  ///         }
  ///
  ///         if (errorReport.exists(_b) {
  ///           return State.error(errorReport.of(_b));
  ///         }
  ///       }
  ///
  ///       if (a != null && b != null) {
  ///         return State(
  ///           foo: a.foo,
  ///           bar: a.bar,
  ///         );
  ///       }
  ///
  ///       // If a or b are null, return null,
  ///       // and no next state will be emitted
  ///       return null;
  ///     });
  FutureOr<State?> computeState() => null;

  /// Schedules a compute state
  /// if [handler] is provided, then this method will be executed
  /// right before [computeState] triggers.
  void scheduleComputeState(FutureOr Function()? handler) async {
    if (handler != null) {
      await handler();
    }

    _computeStateNow();
  }

  Future<void> _computeStateNow() async {
    if (!_didInitHandlers) {
      return;
    }

    final nextState = await computeState();

    if (nextState != null) emit(nextState);
  }

  @override
  Future<void> close() {
    _subscriptions.dispose();

    for (var subject in _subjects) {
      subject.close();
    }

    _subscriptions.clear();
    _subjects.clear();

    return super.close();
  }

  /// Pauses all active subscriptions [consume, pipe]
  void pauseAllSubscriptions([Future<void>? resumeSignal]) =>
      _subscriptions.pauseAll();

  /// Resumes all active subscriptions [consume, pipe]
  void resumeAllSubscriptions() => _subscriptions.resumeAll();

  /// Consumes the [useCase] as a `Stream` and wraps the `Sink.add` handler,
  /// which can then be resolved to a `Cubit`'s state.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel],
  /// or use [UseCaseSinkResolver.close] to terminate the `sink`.
  ///
  /// When using [UseCaseSinkResolver.close], then be aware that any future
  /// incoming events will throw a [StateError] on that same `sink`.
  UseCaseSink<In, Out> pipe<In, Out>(
    UseCase<In, Out> useCase,
  ) {
    final controller = StreamController<In>();

    _subjects.add(controller);

    return UseCaseSink(
      controller.sink,
      controller.stream.switchedBy(useCase),
      () async {
        final nextState = await computeState();

        if (nextState != null) emit(nextState);
      },
      _subscriptions,
    );
  }

  /// Consumes the [useCase] as an open `Stream`.
  /// The connection stays open, until `close` is called on the `Cubit`.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel].
  UseCaseValueStream<Out> consume<In, Out>(
    UseCase<In, Out> useCase, {
    required In initialData,
  }) =>
      UseCaseValueStream(
        Stream<In>.value(initialData).switchedBy(useCase),
        () async {
          final nextState = await computeState();

          if (nextState != null) emit(nextState);
        },
        _subscriptions,
      );
}
